variable "subscription_id" {
  description = "Azure subscription ID. Required by azurerm 4.x even with Azure CLI auth. Use: az account show --query id -o tsv"
  type        = string
}

variable "tenant_id" {
  description = "Optional Entra tenant ID. Leave empty when using az login; the Check Point module still requires the variable."
  type        = string
  default     = ""
}

variable "client_id" {
  description = "Optional Service Principal client ID. Leave empty when using az login. The Check Point module still requires this argument."
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "Optional Service Principal secret. Leave empty when using az login. The Check Point module still requires this argument."
  type        = string
  default     = ""
  sensitive   = true
}

variable "authentication_method" {
  description = "How the Check Point module obtains an ARM token for Marketplace/image API calls. Use Azure CLI with az login."
  type        = string
  default     = "Azure CLI"

  validation {
    condition     = contains(["Service Principal", "Azure CLI"], var.authentication_method)
    error_message = "authentication_method must be 'Service Principal' or 'Azure CLI'."
  }
}

variable "location" {
  description = "Azure region for the Virtual WAN, hub, and Check Point NVA."
  type        = string
  default     = "eastus"
}

variable "vwan_name" {
  description = "Name of the Virtual WAN created by the Check Point NVA module (Standard type)."
  type        = string
  default     = "vwan-east"
}

variable "hub_name" {
  description = "Name of the East US virtual hub created by the Check Point NVA module."
  type        = string
  default     = "vhub-eastus"
}

variable "hub_address_prefix" {
  description = "Address prefix for the virtual hub. A non-empty CIDR selects Check Point new-VWAN mode so WAN+hub are created in the same apply. Azure minimum is /24; /23 leaves room for NVA IPs. Hub routing capacity defaults to 2 units (3 Gbps)."
  type        = string
  default     = "10.0.0.0/23"

  validation {
    condition     = can(cidrhost(var.hub_address_prefix, 0))
    error_message = "hub_address_prefix must be a valid CIDR block."
  }
}

variable "checkpoint_managed_app_rg_name" {
  description = "Resource group created by the Check Point module for the Marketplace managed application, Virtual WAN, and East US hub."
  type        = string
  default     = "rg-checkpoint-managed-app"
}

variable "nva_rg_name" {
  description = "Managed resource group that will contain the Check Point NVA resources."
  type        = string
  default     = "rg-checkpoint-nva"
}

variable "managed_app_name" {
  description = "Name of the Check Point Marketplace managed application."
  type        = string
  default     = "cp-vwan-managed-app-nva"
}

variable "nva_name" {
  description = "Name of the Check Point Network Virtual Appliance in the hub."
  type        = string
  default     = "cp-vwan-nva"
}

variable "license_type" {
  description = "Check Point license SKU for the NVA."
  type        = string
  default     = "Full Package (NGTX and Smart-1 Cloud)"

  validation {
    condition = contains([
      "Security Enforcement (NGTP)",
      "Full Package (NGTX and Smart-1 Cloud)",
      "Full Package Premium (NGTX and Smart-1 Cloud Premium)"
    ], var.license_type)
    error_message = "license_type must be a Check Point NVA license SKU."
  }
}

variable "sic_key" {
  description = "Secure Internal Communication one-time secret (8-30 alphanumeric). Required by the Check Point module even when using Smart-1 Cloud."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{8,30}$", var.sic_key))
    error_message = "sic_key must be 8-30 alphanumeric characters."
  }
}

variable "admin_ssh_public_key" {
  description = "SSH public key for admin access to the NVA gateway instances."
  type        = string
  default     = ""
}

variable "smart1_cloud_token_a" {
  description = "Smart-1 Cloud token for NVA instance A. Generate from SK180501. Scale unit 10 deploys two instances."
  type        = string
  default     = ""
  sensitive   = true
}

variable "smart1_cloud_token_b" {
  description = "Smart-1 Cloud token for NVA instance B. Generate from SK180501."
  type        = string
  default     = ""
  sensitive   = true
}

variable "tags" {
  description = "Tags applied via the Check Point module (managed-app resource group, WAN, hub, and NVA)."
  type        = map(string)
  default = {
    project     = "azure-vwan-checkpoint"
    environment = "lab"
  }
}
