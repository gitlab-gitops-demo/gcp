terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "gitops-demo"

    workspaces {
      name = "gcp"
    }
  }
}