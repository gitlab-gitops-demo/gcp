// Configure the Google Cloud resources
resource "google_container_cluster" "primary" {
  name               = "gitops-demo-gke"
  location           = "us-west1-a"
  initial_node_count = 5

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      Terraform = "true"
    }
  }
}