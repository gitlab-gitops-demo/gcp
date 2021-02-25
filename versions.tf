terraform {
  required_providers {
    gitlab = {
      source  = "terraform-providers/gitlab"
      version = ">=2.9.0"
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
