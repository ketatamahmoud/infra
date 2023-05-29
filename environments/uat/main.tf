#==================================================================================================
#                                     dev
#==================================================================================================

module "uat_vm" {
  source                             = "../../modules/vm"
  env                                = "Uat"
  resource_group_details             = var.resource_group_details
  network_interface_ip_configuration = var.network_interface_ip_configuration
  subnet_id                          = var.subnet_id
  vm_details               = var.uat_vm_details
  local_source_folder_path = var.local_source_folder_path
  install_script_name      = var.install_script_name
  business_group_id        = var.business_group_id
  anypoint_client_id       = var.anypoint_client_id
  anypoint_client_secret   = var.anypoint_client_secret
  nexusBaseAuth            = var.nexusBaseAuth
  server_name             = var.uat_server_name


}

