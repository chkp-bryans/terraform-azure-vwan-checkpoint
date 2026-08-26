module "checkpoint_nva" {
  source  = "CheckPointSW/cloudguard-network-security/azure//modules/nva"
  version = "~> 1.0"

  # Nested Check Point providers still require these four arguments.
  # With authentication_method = "Azure CLI", client_id/secret/tenant stay empty.
  authentication_method = var.authentication_method
  subscription_id       = var.subscription_id
  tenant_id             = var.tenant_id
  client_id             = var.client_id
  client_secret         = var.client_secret

  resource_group_name = var.checkpoint_managed_app_rg_name
  location            = var.location
  tags = {
    all = var.tags
  }

  # Non-empty hub CIDR selects new-VWAN mode: the module creates Virtual WAN + hub
  # in this resource group (no plan-time data.azurerm_virtual_hub lookup).
  vwan_name               = var.vwan_name
  vwan_hub_name           = var.hub_name
  vwan_hub_address_prefix = var.hub_address_prefix

  managed_app_name = var.managed_app_name
  nva_rg_name      = var.nva_rg_name
  nva_name         = var.nva_name
  os_version       = "R82"
  license_type     = var.license_type
  scale_unit       = "10"
  sic_key            = var.sic_key
  admin_SSH_key      = var.admin_ssh_public_key
  new_public_ip      = "yes"
  existing_public_ip = ""

  smart1_cloud_token_a = var.smart1_cloud_token_a
  smart1_cloud_token_b = var.smart1_cloud_token_b

  routing_intent_internet_traffic = "yes"
  routing_intent_private_traffic  = "yes"

  # Do not set depends_on, count, or for_each: the Check Point module configures its own providers.
}
