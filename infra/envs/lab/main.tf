terraform {
  required_version = ">= 1.6.0"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.14"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "lab" {
  name     = "${var.name_prefix}-rg"
  location = var.location
  tags     = var.tags
}

module "networking" {
  source              = "../../modules/networking"
  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
}

module "dns" {
  source              = "../../modules/dns"
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.lab.name
  vnet_id             = module.networking.vnet_id
  public_zone_name    = var.public_zone_name
}

module "aks" {
  source              = "../../modules/aks"
  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  aks_subnet_id       = module.networking.aks_subnet_id
}

module "database" {
  source               = "../../modules/database"
  name_prefix          = var.name_prefix
  location             = var.location
  resource_group_name  = azurerm_resource_group.lab.name
  data_subnet_id       = module.networking.data_subnet_id
  private_dns_zone_id  = module.dns.postgres_private_dns_zone_id
}

module "storage" {
  source              = "../../modules/storage"
  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
}

module "identity" {
  source              = "../../modules/identity"
  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.lab.name
  github_org          = var.github_org
  github_repo         = var.github_repo
}

resource "azurerm_role_assignment" "gha_acr" {
  scope                = module.aks.acr_id
  role_definition_name = "AcrPush"
  principal_id         = module.identity.github_identity_principal_id
}
