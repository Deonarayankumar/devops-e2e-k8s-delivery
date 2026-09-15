variable "name_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}

resource "azurerm_user_assigned_identity" "github" {
  name                = "${var.name_prefix}-gha-id"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_federated_identity_credential" "github" {
  name                = "github-actions"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.github.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
}

output "github_identity_client_id" {
  value = azurerm_user_assigned_identity.github.client_id
}

output "github_identity_id" {
  value = azurerm_user_assigned_identity.github.id
}

output "github_identity_principal_id" {
  value = azurerm_user_assigned_identity.github.principal_id
}
