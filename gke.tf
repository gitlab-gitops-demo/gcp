// Configure the Google Cloud resources
resource "google_container_cluster" "primary" {
  name                     = "gitops-demo-gke"
  location                 = "us-west1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  min_master_version       = "1.20"
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-west1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = "n1-standard-4"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

output "env-dynamic-url" {
  value = "https://${google_container_cluster.primary.endpoint}"
}