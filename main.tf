locals {

  regions = {
    brazilsouth = "zb1"
    eastus      = "zu1"
    eastus2     = "zu2"
    northeurope = "neu"
    westeurope  = "weu"
    uksouth     = "suk"
    westus      = "wus"
  }

  geo_region = lookup(local.regions, var.location)
}

data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_key_vault" "key_vault" {

  name                            = join("", [var.name, var.environment, local.geo_region, "akv"])
  resource_group_name             = data.azurerm_resource_group.resource_group.name
  location                        = var.location
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled        = true
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = false
  enabled_for_template_deployment = true
  sku_name                        = var.sku_name

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = var.ip_rules
  }

  tags = merge({
    description = var.description
  }, var.custom_tags)

  depends_on = [data.azurerm_client_config.current, data.azurerm_resource_group.resource_group]
}

resource "azurerm_key_vault_access_policy" "access_policy" {

  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Encrypt",
    "Decrypt",
    "WrapKey",
    "UnwrapKey",
    "Sign",
    "Verify",
    "Get",
    "List",
    "Create",
    "Update",
    "Import",
    "Delete",
    "Backup",
    "Restore",
    "Recover",
    "Purge"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Backup",
    "Restore",
    "Recover",
    "Purge"
  ]

  certificate_permissions = [
    "Get",
    "List",
    "Delete",
    "Create",
    "Import",
    "Update",
    "Managecontacts",
    "Getissuers",
    "Listissuers",
    "Setissuers",
    "Deleteissuers",
    "Manageissuers",
    "Recover",
    "Purge",
    "Backup",
    "Restore"
  ]

  storage_permissions = [
    "Get",
    "List",
    "Delete",
    "Set",
    "Update",
    "Regeneratekey",
    "Recover",
    "Purge",
    "Backup",
    "Restore",
    "Setsas",
    "Listsas",
    "Getsas",
    "Deletesas"
  ]

  depends_on = [azurerm_key_vault.key_vault]
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic" {
  name                       = azurerm_key_vault.key_vault.name
  target_resource_id         = azurerm_key_vault.key_vault.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id

  log {
    category = "AuditEvent"
    enabled  = true
    retention_policy {
      enabled = true
      days    = "30"
    }
  }
  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = false
    retention_policy {
      days    = 0
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = "30"
    }
  }

  depends_on = [azurerm_key_vault.key_vault, data.azurerm_log_analytics_workspace.log_analytics]
}
