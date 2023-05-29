#==================================================================================================
#                                     public_ip
#==================================================================================================

module "public_ip" {
  source            = "./public_ip"
  public_ip_details = {
    name               =  join("_", [var.env,var.resource_group_details.name, "public_ip"])
    allocation_method = var.public_ip_allocation_method
  }
  resource_group_details = var.resource_group_details
}

#==================================================================================================
#                                     network_interface
#==================================================================================================

module "network_interface" {
  source     = "./network_interface"
  depends_on = [
    module.public_ip,
  ]
  network_interface_details = {
    name = join("_", [var.env,var.resource_group_details.name, "network_interface"]),
    ip_configuration= var.network_interface_ip_configuration
  }
  resource_group_details    = var.resource_group_details
  subnet_id                 = var.subnet_id
  public_ip_address_id      = module.public_ip.public_ip_address_id
}

#==================================================================================================
#                                    linux_vm
#==================================================================================================

locals {
  script_arguments= join(" ",[var.business_group_id,var.anypoint_client_id,var.anypoint_client_secret,var.env,var.nexusBaseAuth,var.server_name])
}
module "linux_vm" {
  source     = "./linux_vm"
  depends_on = [
    module.network_interface
  ]
  resource_group_details = var.resource_group_details
  network_interface_ids  = [module.network_interface.network_interface_ids]

  vm_name = join("_", [var.env,"VM"])
  vm_details = var.vm_details
  install_script_name = var.install_script_name
  local_source_folder_path = var.local_source_folder_path


  env = var.env
  script_arguments = local.script_arguments
}
