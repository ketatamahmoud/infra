#================================================================================================
#                                              virtual_network
#================================================================================================

resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet_details.name
  address_space       = var.vnet_details.address_space
  location            = var.resource_group_details.location
  resource_group_name = var.resource_group_details.name

}

#================================================================================================
#                                              subnet
#================================================================================================

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_details.name
  resource_group_name  = var.resource_group_details.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.subnet_details.address_space]
  depends_on           = [
    azurerm_virtual_network.virtual_network
  ]
}

#================================================================================================
#                                              network_security_group
#================================================================================================

resource "azurerm_network_security_group" "nsg" {
  name                = var.security_group_details.name
  location            = var.resource_group_details.location
  resource_group_name = var.resource_group_details.name
    depends_on          = [
        azurerm_virtual_network.virtual_network
    ]
  #  tags = var.security_group_details.tags
}

#================================================================================================
#                                              network_security_rule
#================================================================================================

module "security_rules" {
  source     = "./security_rules"
  depends_on = [
    azurerm_network_security_group.nsg

  ]
  for_each = {for idx, rule in var.security_rules_list_details : idx => rule}

  network_security_rule_details = each.value
  network_security_group_name   = azurerm_network_security_group.nsg.name
  resource_group_name           = var.resource_group_details.name

}

#================================================================================================
#                                              subnet_network_security_group_association
#================================================================================================

resource "azurerm_subnet_network_security_group_association" "vm_nsg_association" {

  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on                = [
    azurerm_subnet.subnet,
    module.security_rules,
    azurerm_network_security_group.nsg
  ]
}



