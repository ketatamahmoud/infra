#================================================================================================
#                                        network_interface_details
#================================================================================================

variable "network_interface_details" {
  description = "The network interface details"
  type= object({
    name = string
    ip_configuration = object({
      name = string
      private_ip_address_allocation = string
    })

  })
}
#================================================================================================
#                                        resource_group_details
#================================================================================================

variable "resource_group_details" {
    description = "The resource group details"
    type= object({
        name = string
        location = string
    })
}

#================================================================================================
#                                        subnet_id
#================================================================================================
variable "subnet_id" {
    description = "The subnet id"
    type= string
}
#================================================================================================
#                                        public_ip_address_id
#================================================================================================
variable "public_ip_address_id" {
    description = "The public ip address id"
    type= string
}