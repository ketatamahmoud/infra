#====================================================================================================================
#                                                    resource_group
#====================================================================================================================
variable "resource_group_details" {
  description = "This contains all of the vm details"
  type        = object({
    name     = string
    location = string
  })

}
#====================================================================================================================
#                                                    subnetId
#====================================================================================================================
variable "subnet_id" {
  description = "This contains all of the vm details"
  type        = string
}



#====================================================================================================================
#                                                    network_interface
#====================================================================================================================
variable "network_interface_ip_configuration" {
  description = "This contains all of the network interface details"
  type        = object({
    name                          = string
    private_ip_address_allocation = string
  })
}


#====================================================================================================================
#                                                    dev_virtual_machine
#====================================================================================================================
variable "dev_vm_details" {
  description = "This contains all of the vm details"
  default     = {
    name           = "dev-customer"
    size           = "Standard_B2ms"
    path_linux_key  = "ssh"
    admin_username = "mahmoud"


    os = {
      storage_account_type = "Standard_LRS"
      caching              = "ReadWrite"
      publisher            = "Canonical"
      offer                = "UbuntuServer"
      sku                  = "18.04-LTS"
      version              = "latest"
    },


    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }


}
variable "local_source_folder_path" {
  description = "This contains the details of the script to be executed"
  type        = string
}
variable "install_script_name" {
  description = "This contains the path to the install script"
  type = string
}


variable "dev_server_name" {
  description = "This contains the server token"
    type        = string

}



variable "nexusBaseAuth" {
  description = "This contains the nexus base auth"
  type        = string
}

variable "business_group_id" {
  description = "This contains the business group id"
  type        = string
}
variable "anypoint_client_id" {
  description = "This contains the anypoint client id"
  type        = string
}
variable "anypoint_client_secret" {
  description = "This contains the anypoint client secret"
  type        = string
}