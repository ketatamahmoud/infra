#==================================================================================================
#                                     resource_group
#==================================================================================================

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_details.name
  location = var.resource_group_details.location

}

#==================================================================================================
#                                    vertical_network
#==================================================================================================

module "virtual_network" {
  source     = "./modules/virtual_network"
  depends_on = [
    azurerm_resource_group.rg
  ]
  security_rules_list_details = [var.RULE_Allow_mule_ports, var.Rule_Allow_SSH,var.outbound-allow-443]
  resource_group_details      = var.resource_group_details
  security_group_details      = var.security_group_details
  subnet_details              = var.subnet_details
  vnet_details                = var.vnet_details

}

#==================================================================================================
#                                     dev
#==================================================================================================
module "dev_vm" {
  source                   = "./dev"
  depends_on = [
    azurerm_resource_group.rg,
    module.virtual_network
  ]
  resource_group_details   = var.resource_group_details
  subnet_id                = module.virtual_network.subnet_id
  network_interface_ip_configuration = var.network_interface_ip_configuration
  local_source_folder_path = var.local_source_folder_path
  install_script_name      = var.install_script_name
  nexusBaseAuth            = var.nexusBaseAuth
  dev_server_name          = var.dev_server_name
  anypoint_client_id = var.anypoint_client_id
  anypoint_client_secret = var.anypoint_client_secret
  business_group_id = var.business_group_id
}
#==================================================================================================
#                                     uat
#==================================================================================================
#variable "uat_server_token" {
#  default = ""
#}
#module "uat_vm" {
#  source                   = "./uat"
#    depends_on = [
#        azurerm_resource_group.rg,
#        module.virtual_network
#    ]
#  resource_group_details   = var.resource_group_details
#  subnet_id                = module.virtual_network.subnet_id
#  network_interface_ip_configuration = var.network_interface_ip_configuration
#  local_source_folder_path = var.local_source_folder_path
#  install_script_name      = var.install_script_name
#  nexusBaseAuth            = var.nexusBaseAuth
#  uat_server_name          = var.uat_server_name
#
#  anypoint_client_id = var.anypoint_client_id
#  anypoint_client_secret = var.anypoint_client_secret
#  business_group_id = var.business_group_id
#}



























##==================================================================================================
##                                     dev
##==================================================================================================
#module "uat" {
#  source = "./vm"
#  resource_group_details = var.resource_group_details
#  network_interface_ip_configuration = var.network_interface_ip_configuration
#  subnet_id = module.virtual_network.subnet_id
#  env = "uat"
#  vm_details = var.dev_vm_details
#  local_source_folder_path = var.local_source_folder_path
#  install_script_name = var.install_script_name
#  script_arguments = var.script_arguments
#}
##==================================================================================================
##                                     dev
##==================================================================================================
#module "ppd_vm" {
#  source = "./vm"
#  resource_group_details = var.resource_group_details
#  network_interface_ip_configuration = var.network_interface_ip_configuration
#  subnet_id = module.virtual_network.subnet_id
#  env = "ppd"
#  vm_details = var.dev_vm_details
#  local_source_folder_path = var.local_source_folder_path
#  install_script_name = var.install_script_name
#  script_arguments = var.script_arguments
#}
##==================================================================================================
##                                     dev
##==================================================================================================
#module "prd_vm" {
#  source = "./vm"
#  resource_group_details = var.resource_group_details
#  network_interface_ip_configuration = var.network_interface_ip_configuration
#  subnet_id = module.virtual_network.subnet_id
#  env = "prd"
#  vm_details = var.dev_vm_details
#  local_source_folder_path = var.local_source_folder_path
#  install_script_name = var.install_script_name
#  script_arguments = var.script_arguments
#}
#
#
#



