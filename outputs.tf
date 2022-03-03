output "key_vault_name" {
  description = "The name of Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "key_vault_id" {
  description = "The ID of Key Vault"
  value       = azurerm_key_vault.key_vault.id
}
