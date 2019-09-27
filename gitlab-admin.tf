data "google_client_config" "current" {}

provider "kubernetes" {
  version                = "~> 1.9"
  host                   = "${google_container_cluster.primary.endpoint}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
  token                  = "${data.google_client_config.current.access_token}"
  load_config_file       = false
}

resource "kubernetes_service_account" "gitlab-admin" {
  metadata {
    name      = "gitlab-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_secret" "gitlab-admin" {
  metadata {
    name      = "gitlab-admin"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = "${kubernetes_service_account.gitlab-admin.metadata.0.name}"
    }
  }
  lifecycle {
    ignore_changes = [
      "data"
    ]
  }
  type = "kubernetes.io/service-account-token"
}

data "kubernetes_secret" "gitlab-admin-token" {
  metadata {
    name      = "${kubernetes_service_account.gitlab-admin.default_secret_name}"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "gitlab-admin" {
  metadata {
    name = "gitlab-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "gitlab-admin"
    namespace = "kube-system"
  }
}

locals {
  # GitLab API expects the cert in PEM format with \r\n and no carriage returns.
  # https://docs.gitlab.com/ee/api/project_clusters.html
  cert-one-line = "${replace(base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate), "\n", "\\r\\n")}"

  gitlab-config = <<EOT
{"name":"${google_container_cluster.primary.name}",
 "domain":"gitops-demo.com",
"platform_kubernetes_attributes":
{"api_url":"${google_container_cluster.primary.endpoint}",
"token":"${data.kubernetes_secret.gitlab-admin-token.data.token}",
"ca_cert":"${local.cert-one-line}"}
}
  EOT
}

resource "local_file" "gitlab-config" {
  sensitive_content = local.gitlab-config
  filename          = "gitlab-k8s-config"
}
