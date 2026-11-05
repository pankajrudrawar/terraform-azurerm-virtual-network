variable "create" {
  description = "Controls whether any resources are created by this module"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group that holds the virtual network"
  type        = string
}

variable "location" {
  description = "Azure region, for example `eastus2`"
  type        = string
}

variable "address_space" {
  description = "CIDR blocks of the virtual network address space"
  type        = list(string)
}

variable "dns_servers" {
  description = "Custom DNS server IPs. Uses Azure-provided DNS when null"
  type        = list(string)
  default     = null
}

variable "subnets" {
  description = "Map of subnets keyed by subnet name"
  type = map(object({
    address_prefixes                  = list(string)
    service_endpoints                 = optional(list(string), [])
    private_endpoint_network_policies = optional(string, "Disabled")
    default_outbound_access_enabled   = optional(bool, true)
    delegation = optional(object({
      service_name = string
      name         = optional(string, "delegation")
      actions      = optional(list(string))
    }))
    create_network_security_group = optional(bool, false)
    network_security_rules = optional(map(object({
      priority                   = number
      direction                  = optional(string, "Inbound")
      access                     = optional(string, "Allow")
      protocol                   = optional(string, "Tcp")
      source_port_range          = optional(string, "*")
      destination_port_range     = optional(string, "*")
      source_address_prefix      = optional(string, "*")
      destination_address_prefix = optional(string, "*")
      description                = optional(string)
    })), {})
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
