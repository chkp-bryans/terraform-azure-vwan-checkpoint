output "vwan_resource_group_name" {
  description = "Managed-app resource group that owns the Virtual WAN, East US hub, and Check Point managed application."
  value       = module.checkpoint_nva.resource_group_name
}

output "virtual_hub_id" {
  description = "Resource ID of the East US virtual hub created by the Check Point NVA module."
  value       = module.checkpoint_nva.vwan_hub_id
}

output "virtual_hub_virtual_router_asn" {
  description = "ASN of the East US virtual hub's built-in router."
  value       = module.checkpoint_nva.vwan_hub_virtual_router_asn
}

output "virtual_hub_virtual_router_ips" {
  description = "IP addresses of the East US virtual hub's built-in router."
  value       = module.checkpoint_nva.vwan_hub_virtual_router_ips
}

output "checkpoint_managed_app_id" {
  description = "Resource ID of the Check Point Marketplace managed application."
  value       = module.checkpoint_nva.managed_app_id
}

output "checkpoint_nva_resource_group_name" {
  description = "Resource group created for the Check Point managed application (also contains the WAN and hub)."
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
