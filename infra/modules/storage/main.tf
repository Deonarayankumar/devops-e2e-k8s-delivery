variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

resource "azurerm_storage_account" "this" {
  name                            = substr(replace("${var.name_prefix}data", "-", ""), 0, 24)
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
}

resource "azurerm_storage_container" "velero" {
  name                  = "velero"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "app" {
  name                  = "app-artifacts"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

output "account_name" {
  value = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}

output "velero_container" {
  value = azurerm_storage_container.velero.name
}
