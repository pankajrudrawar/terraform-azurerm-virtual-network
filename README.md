# terraform-azurerm-virtual-network

Terraform module for an Azure virtual network with subnets, service endpoints, delegations and optional per-subnet network security groups.

[![Validate](https://github.com/pankajrudrawar/terraform-azurerm-virtual-network/actions/workflows/validate.yml/badge.svg)](https://github.com/pankajrudrawar/terraform-azurerm-virtual-network/actions/workflows/validate.yml)
[![Terraform Registry](https://img.shields.io/badge/registry-pankajrudrawar%2Fvirtual--network%2Fazurerm-7B42BC?logo=terraform&logoColor=white)](https://registry.terraform.io/modules/pankajrudrawar/virtual-network/azurerm)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
![Terraform](https://img.shields.io/badge/terraform-%E2%89%A5%201.5.7-7B42BC?logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-module-0078D4)

## Features

- Subnets defined as a map with service endpoints and private endpoint network policies
- Subnet delegation for services such as Azure NetApp Files
- Optional network security group per subnet with rules defined as a map
- Custom DNS servers

## Usage

```hcl
module "virtual_network" {
  source  = "pankajrudrawar/virtual-network/azurerm"
  version = "~> 0.1"

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
```

A complete, runnable configuration is in [`examples/basic`](examples/basic).

## Notes

- Each subnet with `create_network_security_group = true` gets an NSG named `nsg-<subnet name>` and an association.

## Module reference

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| azurerm | >= 4.0, < 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Controls whether any resources are created by this module | `bool` | `true` | no |
| name | Name of the virtual network | `string` | n/a | yes |
| resource_group_name | Name of the resource group that holds the virtual network | `string` | n/a | yes |
| location | Azure region, for example `eastus2` | `string` | n/a | yes |
| address_space | CIDR blocks of the virtual network address space | `list(string)` | n/a | yes |
| dns_servers | Custom DNS server IPs. Uses Azure-provided DNS when null | `list(string)` | `null` | no |
| subnets | Map of subnets keyed by subnet name | `map(object)` | `{}` | no |
| tags | Tags applied to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Resource ID of the virtual network |
| name | Name of the virtual network |
| address_space | Address space of the virtual network |
| subnet_ids | Map of subnet resource IDs keyed by subnet name |
| subnet_address_prefixes | Map of subnet address prefixes keyed by subnet name |
| network_security_group_ids | Map of network security group resource IDs keyed by subnet name |
<!-- END_TF_DOCS -->

## Contributing

Issues and pull requests are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) first, and ask questions in [Discussions](https://github.com/pankajrudrawar/terraform-azurerm-virtual-network/discussions). Run `pre-commit run -a` before opening a pull request. It formats the code, validates it, runs TFLint and refreshes the reference tables above with terraform-docs.

Security problems should be reported privately. See [SECURITY.md](SECURITY.md).

## License

Apache 2.0. See [LICENSE](LICENSE).
