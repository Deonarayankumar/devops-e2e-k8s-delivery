variable "name_prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "dns_zone_name" {
  type    = string
  default = "shop.internal"
}

variable "public_zone_name" {
  type    = string
  default = "example.com"
}

resource "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "${var.name_prefix}-pg-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_zone" "internal" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_zone" "public" {
  name                = var.public_zone_name
  resource_group_name = var.resource_group_name
}

output "postgres_private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres.id
}

output "public_zone_name_servers" {
  value = azurerm_dns_zone.public.name_servers
}
