default_max_request_duration = "90s"
disable_clustering           = true
disable_mlock                = true
ui                           = true

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

seal "azurekeyvault" {}

storage "azure" {
  accountName = "${az_storage_account_name}"
  accountKey  = "${az_storage_account_key}"
  container   = "${az_storage_container_name}"
}
