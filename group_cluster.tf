data "gitlab_group" "gitops-demo-apps" {
  full_path = "gitops-demo/apps"
}

data "gitlab_projects" "cluster-management-search" {
  # Returns a list of matching projects. limit to 1 result matching "cluster-management"
  group_id            = data.gitlab_group.gitops-demo-apps.id
  simple              = true
  search              = "cluster-management"
  per_page            = 1
  max_queryable_pages = 1
}

provider "gitlab" {
  version = ">=2.9.0"
}

resource "gitlab_group_cluster" "gke_cluster" {
  group              = data.gitlab_group.gitops-demo-apps.id
  name               = google_container_cluster.primary.name
  domain             = "gke.gitops-demo.com"
  environment_scope  = "*"
  kubernetes_api_url = "https://${google_container_cluster.primary.endpoint}"
  kubernetes_token   = data.kubernetes_secret.gitlab-admin-token.data.token
  kubernetes_ca_cert = trimspace(base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate))
  management_project_id = data.gitlab_projects.cluster-management-search.projects.0.id
}
