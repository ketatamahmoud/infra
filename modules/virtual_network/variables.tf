#variable "location" {
#  description = "The location where the resource group will be created"
#}
#
#variable "virtual_network_name" {
#  description = "The name of the virtual network"
#  type        = string
#}
#
#variable "virtual_network_cidr" {
#  description = "The CIDR block for the virtual network"
#  type        = string
#}
#
#variable "subnet_name" {
#  description = "The name of the subnet"
#  type        = string
#}
#
#variable "subnet_cidr" {
#  description = "The CIDR block for the subnet"
#  type        = string
#}
#variable "resource_group_name" {
#  description = "The name of the resource group"
#  type        = string
#}
#variable "subnets" {
#  description = "The subnets to create"
#  type        = list(object({
#    name = string
#    cidr = string
#  }))
#}
#variable "address_space" {
#  description = "The address space to use for the virtual network"
#  type        = string
#}
#variable "nsg_rule_details" {
#  description = "This contains all of the nsg rule details"
#  default     = {
#    name                       = "cel_customer_nsg_rule"
#    access                     = "Allow"
#    direction                  = "Inbound"
#    priority                   = 100
#    protocol                   = "Tcp"
#    source_port_range          = "*"
#    destination_port_range     = "22"
#    source_address_prefix      = "*"
#    destination_address_prefix = "*"
#  }
#}
#**********************************************************************************************************************











#variable "network_security_rule_details"  {
#  description = "This contains all of the network security rule details"
#  type        = object({
#    name                       = string
#    access                     = string
#    direction                  = string
#    priority                   = number
#    protocol                   = string
#    source_port_range          = string
#    destination_port_range     = string
#    source_address_prefix      = string
#    destination_address_prefix = string
#  })
#}
#======================================================================================================================
#                                           vnet_details
#======================================================================================================================
variable "vnet_details" {
  description = "This contains all of the vnet details"
  type        = object({
    name          = string
    address_space = list(string)


  })
}
#======================================================================================================================
#                                           resource_group_details
#======================================================================================================================

variable "resource_group_details" {
  description = "This contains all of the vm details"
  type        = object({
    name     = string
    location = string
  })

}

#======================================================================================================================
#                                           subnet_details
#======================================================================================================================
variable "subnet_details" {
  description = "This contains all of the subnet details"
  type        = object({
    name                 = string
    address_space        = string
  })
}
#======================================================================================================================
#                                           security_rules_list_details
#======================================================================================================================
variable "security_rules_list_details" {
  description = "This contains all of the security rules"
  type        = list(object({
    name : string
    priority : number
    direction : string
    access : string
    protocol : string
    source_port_range : string
    destination_port_range : string
    source_address_prefix : string
    destination_address_prefix : string
  }))
}
#======================================================================================================================
#                                           network_security_group_details
#======================================================================================================================
variable "security_group_details" {
  description = "This contains all of the security group details"
  type        = object({
    name                = string
    location            = string
  })
}