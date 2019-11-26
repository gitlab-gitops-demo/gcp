data "gitlab_group" "gitops-demo-apps" {
  full_path = "gitops-demo/apps"
}

resource "gitlab_group_cluster" "gke_cluster" {
  group              = data.gitlab_group.gitops-demo-apps.id
  name               = google_container_cluster.primary.name
  domain             = "gke.gitops-demo.com"
  environment_scope  = "*"
  kubernetes_api_url = "https://${google_container_cluster.primary.endpoint}"
  kubernetes_token   = data.kubernetes_secret.gitlab-admin-token.data.token
  kubernetes_ca_cert = trimspace(base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate))

}