output "vwan_resource_group_name" {
  description = "Resource group that owns the Virtual WAN and East US hub."
  value       = azurerm_resource_group.vwan.name
}

output "vwan_id" {
  description = "Resource ID of the Standard Virtual WAN."
  value       = azurerm_virtual_wan.this.id
}

output "virtual_hub_id" {
  description = "Resource ID of the East US virtual hub."
  value       = azurerm_virtual_hub.east.id
}

output "virtual_hub_default_route_table_id" {
  description = "Default route table of the East US virtual hub."
  value       = azurerm_virtual_hub.east.default_route_table_id
}

output "checkpoint_managed_app_id" {
  description = "Resource ID of the Check Point Marketplace managed application."
  value       = module.checkpoint_nva.managed_app_id
}

output "checkpoint_nva_resource_group_name" {
  description = "Resource group created for the Check Point managed application."
  value       = module.checkpoint_nva.resource_group_name
}

output "checkpoint_nva_managed_resource_group_id" {
  description = "Managed resource group that contains the NVA resources."
  value       = module.checkpoint_nva.managed_resource_group_id
}

output "checkpoint_routing_intent_id" {
  description = "Hub routing intent resource ID. Null if routing intent was not enabled."
  value       = module.checkpoint_nva.routing_intent_id
}

output "checkpoint_image_version" {
  description = "CloudGuard NVA image version selected by the Check Point module."
  value       = module.checkpoint_nva.image_version
}
