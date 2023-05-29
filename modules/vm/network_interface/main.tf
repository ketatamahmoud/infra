resource "azurerm_network_interface" "network_interface" {

  name                = var.network_interface_details.name
  location            = var.resource_group_details.location
  resource_group_name = var.resource_group_details.name

  ip_configuration {
    name                          = var.network_interface_details.ip_configuration.name
    public_ip_address_id          = var.public_ip_address_id
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.network_interface_details.ip_configuration.private_ip_address_allocation
  }
}