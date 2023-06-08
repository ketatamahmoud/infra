#====================================================================================================================
#                                                    resource_group
#====================================================================================================================

variable "resource_group_details" {

  default = {
    name     = "MULE_RG"
    location = "France central"
  }
}

#====================================================================================================================
#                                                    virtual_network
#====================================================================================================================


variable "security_group_details" {
  description = "This contains all of the security group details"
  default     = {
    name     = "MULE_cel_customer_security_group"
    location = "France central"
  }
}
variable "subnet_details" {
  description = "This contains all of the subnet details"
  default     = {
    name          = "MULE_cel_customer_subnet"
    address_space = "10.0.1.0/24"


  }
}
variable "vnet_details" {
  description = "This contains all of the vnet details"
  default     = {
    name          = "cel_customer_vnet",
    address_space = ["10.0.0.0/16"],
    subnet_name   = "cel_customer_subnet",
    subnet_prefix = "10.0.1.0/24"
  }
}
#====================================================================================================================
#                                                    network_security
#====================================================================================================================
variable "RULE_Allow_mule_ports" {
  description = "network security rule that allows incoming traffic on ports 8080 to 8082 for the destination address prefix"
  default     = {
    name                       = "allow_mule_ports"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080-8084"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

variable "Rule_Allow_SSH" {
  description = "network security rule that allows incoming SSH traffic on port 22"
  default     = {

    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
variable "outbound-allow-443" {
  description = "network security rule that allows incoming SSH traffic on port 22"
  default     = {

    name                       = "outbound-allow-443"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#====================================================================================================================
#                                                    network_interface
#====================================================================================================================
variable "network_interface_ip_configuration" {
  description = "This contains all of the network interface details"
  default     = {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
  }

}



#====================================================================================================================
#                                                    virtual_machine
#====================================================================================================================
variable "install_script_name" {
  description = "This contains the path to the install script"
  default     = "install.sh"
}
variable "local_source_folder_path" {
  description = "This contains the details of the script to be executed"
  default     = "local_source_folder"


}
variable "nexusBaseAuth" {
  type = string
}

#====================================================================================================================
#                                                    dev_virtual_machine
#====================================================================================================================

#
#variable "dev_server_name" {
#    type = string
#}

#====================================================================================================================
#                                                    uat_virtual_machine
#====================================================================================================================


#variable "uat_server_name" {
#  type = string
#}

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
