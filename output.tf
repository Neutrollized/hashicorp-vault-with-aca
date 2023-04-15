output "_0_vault_config_upload" {
  value = "az storage file upload --account-name ${azurerm_storage_account.vault_storage_account.name} --share-name ${azurerm_storage_share.vault_config.name} --source vault-server.hcl"
}

output "_1_image_build" {
  value = "az acr build --image vault:${var.vault_version} --registry ${azurerm_container_registry.vault_acr.name} --file Dockerfile ."
}

output "_2_container_instance_create" {
  value = <<EOT
az containerapp create --resource-group ${azurerm_resource_group.vault_rg.name} \
  --name ${var.vault_name} \
  --yaml app.yaml \
  --query properties.configuration.ingress.fqdn
EOT
}

output "_3_initialize_vault" {
  value = <<EOT
export VAULT_ADDR="https://[FQDN_OF_ACA_FROM_ABOVE_STEP]"
curl -s -X POST $${VAULT_ADDR}/v1/sys/init --data @init.json
EOT
}
