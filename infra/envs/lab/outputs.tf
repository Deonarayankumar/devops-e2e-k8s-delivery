output "resource_group_name" {
  value = azurerm_resource_group.lab.name
}

output "aks_name" {
  value = module.aks.cluster_name
}

output "acr_login_server" {
  value = module.aks.acr_login_server
}

output "postgres_fqdn" {
  value = module.database.fqdn
}

output "github_identity_client_id" {
  value = module.identity.github_identity_client_id
}

output "storage_account_name" {
  value = module.storage.account_name
}

output "dns_name_servers" {
  value = module.dns.public_zone_name_servers
}
