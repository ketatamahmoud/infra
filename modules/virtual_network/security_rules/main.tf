resource "azurerm_network_security_rule" "nsg_rule" {
  name                        = var.network_security_rule_details.name
  priority                    = var.network_security_rule_details.priority
  direction                   = var.network_security_rule_details.direction
  access                      = var.network_security_rule_details.access
  protocol                    = var.network_security_rule_details.protocol
  source_port_range           = var.network_security_rule_details.source_port_range
  destination_port_range      = var.network_security_rule_details.destination_port_range
  source_address_prefix       = var.network_security_rule_details.source_address_prefix
  destination_address_prefix  = var.network_security_rule_details.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.network_security_group_name
}
