variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which the Key Vault is created. Changing this forces a new resource to be created."
}

variable "sku_name" {
  type        = string
  description = "(Opcional) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  default     = "premium"
}

variable "log_analytics_name" {
  description = "(Required) Log Analytics Workspace Name to connect the product."
}

variable "ip_rules" {
  type        = list(any)
  description = "(Optional) The ranges of IPs to can access Key Vault"
  default     = []
}

//NAMING VARIABLES

variable "name" {
  description = "(Required) Name of key vault. Changing this forces a new resource to be created."
  type        = string
}

variable "environment" {
  description = "(Required) Environment of Key Vault. Used for Naming. (3 characters). Changing this forces a new resource to be created. "
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the Resource Group exists. Changing this forces a new resource to be created."
  type        = string
}


// TAGGING VARIABLES

variable "description" {
  description = "(Required) This tag will allow the resource operator to provide additional context information"
  type        = string
}

variable "custom_tags" {
  description = "(Optional) Optional tags."
  type        = map(any)
  default     = {}
}
