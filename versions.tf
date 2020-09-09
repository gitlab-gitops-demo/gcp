terraform {
  required_providers {
    gitlab = {
      source = "terraform-providers/gitlab"
    }
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}
