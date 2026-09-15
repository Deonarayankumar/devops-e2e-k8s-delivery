variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "data_subnet_id" {
  type = string
}

variable "private_dns_zone_id" {
  type = string
}

variable "administrator_login" {
  type    = string
  default = "pgadmin"
}

resource "random_password" "pg" {
  length  = 24
  special = false
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                          = "${var.name_prefix}-pg"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "16"
  sku_name                      = "B_Standard_B1ms"
  storage_mb                    = 32768
  delegated_subnet_id           = var.data_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  administrator_login           = var.administrator_login
  administrator_password        = random_password.pg.result
  public_network_access_enabled = false
  zone                          = "1"
}

resource "azurerm_postgresql_flexible_server_database" "shop" {
  name      = "shop"
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.shop.name
}

output "administrator_login" {
  value = var.administrator_login
}

output "administrator_password" {
  value     = random_password.pg.result
  sensitive = true
}
