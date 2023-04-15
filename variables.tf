#-----------------------
# Azure basic vars
#-----------------------
variable "rg_name" {
  type    = string
  default = "vault-rg"
}

variable "location" {
  type    = string
  default = "canadacentral"
}


#-------------------------
# HashiCorp Vault 
#-------------------------
variable "vault_name" {
  type    = string
  default = "azvault"
}

variable "vault_version" {
  type    = string
  default = "1.13.1"
}

variable "autounseal_sp_client_id" {
  type = string
}

variable "autounseal_sp_client_secret" {
  type = string
}

variable "autounseal_sp_object_id" {
  type = string
}


#-------------------------
# ACR
#-------------------------

variable "acr_name" {
  description = "Name of Azure Container Registry repo. Alphanumeric characters only without spaces."
  type        = string
  default     = "vaultacr"
}


#-------------------------
# Storage Account
#-------------------------
variable "storage_account_name" {
  description = "Name of Azure storage account. Lowercase alphanumeric characters only."
  type        = string
  default     = "vaultstorage"
}

variable "storage_share_name" {
  description = "Name of storage share used to hold the vault-server.hcl to be mounted onto ACI."
  type        = string
  default     = "vault-config"
}

variable "storage_container_name" {
  description = "Name of storage container used as Vault's storage backend."
  type        = string
  default     = "vault-data"
}


#-------------------------
# Azure Key Vault
#-------------------------
variable "akv_name" {
  description = "Name of AKV used to store key used for Auto-unseal."
  type        = string
  default     = "vault-akv"
}

variable "soft_delete_retention_days" {
  type    = number
  default = 7
}


#-----------------------------------
# Azure Log Analytics Workspace
#-----------------------------------
variable "log_analytics_workspace_name" {
  description = "Name of Log Analytics Workspace.  Alphanumeric characters and '-' only"
  type        = string
  default     = "vault-law"
}

variable "log_analytics_sku" {
  description = "SKU of Log Analytics Workspace.  Accepted values: Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, PerGB2018)."
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_days" {
  description = "Workspace data retention in days. Range: 30-730"
  type        = number
  default     = 30
}


#-------------------------
# Azure Container Apps
#-------------------------
variable "aca_env_name" {
  description = "Name of ACA managed environment."
  type        = string
  default     = "vault-aca-env"
}

variable "aca_env_storage_name" {
  description = "Name of this container app environment storage."
  type        = string
  default     = "vault-aca-env-storage"
}
