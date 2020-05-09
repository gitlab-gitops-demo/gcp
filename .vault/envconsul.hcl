vault {
  ssl {
    enabled = true
    verify  = true
  }
  renew_token = true
  retry {
    enabled = true
    attempts = 5
    backoff = "250ms"
    max_backoff = "1m"
  }

}

upcase = true

secret {
    no_prefix = true
    path      = "secret/infrastructure/gcp"
}

secret {
    no_prefix = true
    path      = "secret/infrastructure/terraform"
}

secret {
    no_prefix = true
    path      = "secret/infrastructure/gitlab"
}

exec {
  env {
     blacklist = ["VAULT_*"]
  }
}