output "id" {
  description = "Resource ID of the virtual network"
  value       = try(azurerm_virtual_network.this[0].id, null)
}

output "name" {
  description = "Name of the virtual network"
  value       = try(azurerm_virtual_network.this[0].name, null)
}

output "address_space" {
  description = "Address space of the virtual network"
  value       = try(azurerm_virtual_network.this[0].address_space, [])
}

output "subnet_ids" {
  description = "Map of subnet resource IDs keyed by subnet name"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "subnet_address_prefixes" {
  description = "Map of subnet address prefixes keyed by subnet name"
  value       = { for k, v in azurerm_subnet.this : k => v.address_prefixes }
}

output "network_security_group_ids" {
  description = "Map of network security group resource IDs keyed by subnet name"
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
}
