terraform {
  required_version = ">= 1.5.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

variable "subscription_id" {
  description = "Azure subscription ID. Falls back to the ARM_SUBSCRIPTION_ID environment variable when null"
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus2"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-network-example"
  location = var.location
}

module "virtual_network" {
  source = "../.."

  name                = "vnet-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.30.0.0/16"]

  subnets = {
    app = {
      address_prefixes              = ["10.30.1.0/24"]
      service_endpoints             = ["Microsoft.Storage"]
      create_network_security_group = true

      network_security_rules = {
        allow-https-in = {
          priority               = 100
          destination_port_range = "443"
          description            = "Allow HTTPS from within the virtual network"
          source_address_prefix  = "VirtualNetwork"
        }
      }
    }

    netapp = {
      address_prefixes = ["10.30.2.0/24"]

      delegation = {
        service_name = "Microsoft.Netapp/volumes"
        name         = "netapp"
        actions      = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }

  tags = {
    Environment = "example"
    ManagedBy   = "terraform"
  }
}

output "subnet_ids" {
  value = module.virtual_network.subnet_ids
}
