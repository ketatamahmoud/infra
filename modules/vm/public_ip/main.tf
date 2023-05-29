#===============================================================================
#                                       Public IP
#===============================================================================
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_details.name
  location            = var.resource_group_details.location
  resource_group_name = var.resource_group_details.name
  allocation_method   = var.public_ip_details.allocation_method
}