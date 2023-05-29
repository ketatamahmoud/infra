variable "vm_name" {
  description = "The name of the VM"
  type        = string
}
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

    #    tags                  = map(string)

  })

}


variable "resource_group_details" {
  description = "The details of the resource group"
  type        = object({
    name     = string
    location = string
    #    tags     = map(string)

  })

}

variable "network_interface_ids" {
  description = "The ids of the network interface"
  type        = list(string)


}


variable "local_source_folder_path" {
  description = "This contains the path to the install script"
  type        = string
}
variable "install_script_name" {
  description = "This contains the path to the install script"
  type        = string
}
variable "env" {
  description = "This contains the path to the install script"
  type        = string
}
variable "script_arguments" {
  description = "This contains the path to the install script"
  type        = string
}
