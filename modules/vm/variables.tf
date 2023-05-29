#====================================================================================================================
#                                                    resource_group
#====================================================================================================================

variable "resource_group_details" {

  description = "Resource Group  "
  type        = object({
    name     = string
    location = string
  })
}


#====================================================================================================================
#                                                    public_ip
#====================================================================================================================


variable "public_ip_allocation_method" {
  description = "This contains all of the public ip details"
  type        = string
  default     = "Dynamic"
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
#                                                    virtual_machine
#====================================================================================================================


variable "vm_details" {
  description = "The details of the VM"
  type        = object({
    size           = string
    admin_username = string
    path_linux_key  = string


    os = object({
      caching              = string
      storage_account_type = string
      publisher            = string
      offer                = string
      sku                  = string
      version              = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })


  })

}
#====================================================================================================================
#                                                    subnet
#====================================================================================================================


variable "subnet_id" {
  type = string
}
variable "env" {
  description = "This contains the environment details"
  type        = string
  default     = "dev"
}

#====================================================================================================================
#                                                   install_script
#====================================================================================================================
variable "local_source_folder_path" {
  description = "This contains the details of the script to be executed"
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
variable "nexusBaseAuth" {
  description = "This contains the nexus base auth"
  type        = string
}

variable "install_script_name" {
  description = "This contains the details of the script to be executed"
  type        = string

}
variable "server_name" {
  description = ""
  type = string
}

#====================================================================================================================
#
#====================================================================================================================
