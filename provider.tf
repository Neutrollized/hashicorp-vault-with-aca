terraform {
  required_version = "~> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    #    azuredevops = {
    #      source  = "microsoft/azuredevops"
    #      version = "~> 0.4.0"
    #    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy       = true
      purge_soft_deleted_keys_on_destroy = true
      recover_soft_deleted_key_vaults    = false
      recover_soft_deleted_keys          = false
      recover_soft_deleted_secrets       = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

#provider "azuredevops" {
#  AZDO_ORG_SERVICE_URL
#  AZDO_PERSONAL_ACCESS_TOKEN
#}
