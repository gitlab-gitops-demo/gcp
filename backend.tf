terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/14379215/terraform/state/gcp"
    lock_address   = "https://gitlab.com/api/v4/projects/14379215/terraform/state/gcp/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/14379215/terraform/state/gcp/lock"
    username       = "tf"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = "5"
  }
}