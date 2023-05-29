variable "resource_group_name" {
    description = "Resource group name"
    type        = string




}

variable "network_security_group_name" {
    description = "Network security group name"
    type        = string
}

variable "network_security_rule_details" {
    description = "Network security rule details"
    type        = object({
        name : string
        priority : number
        direction : string
        access : string
        protocol : string
        source_port_range : string
        destination_port_range : string
        source_address_prefix : string
        destination_address_prefix : string
    })

}