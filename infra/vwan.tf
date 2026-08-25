resource "azurerm_resource_group" "vwan" {
  name     = var.vwan_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_wan" "this" {
  name                           = var.vwan_name
  resource_group_name            = azurerm_resource_group.vwan.name
  location                       = var.location
  type                           = "Standard"
  allow_branch_to_branch_traffic = true
  tags                           = var.tags
}

resource "azurerm_virtual_hub" "east" {
  name                                   = var.hub_name
  resource_group_name                    = azurerm_resource_group.vwan.name
  location                               = var.location
  virtual_wan_id                         = azurerm_virtual_wan.this.id
  address_prefix                         = var.hub_address_prefix
  sku                                    = "Standard"
  virtual_router_auto_scale_min_capacity = 2
  tags                                   = var.tags
}
