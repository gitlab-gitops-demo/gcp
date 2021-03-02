terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
    }
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.14"
}
