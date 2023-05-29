variable "public_ip_details" {

  description = "Public IP Details"
  type        = object({
    name              = string
    allocation_method = string
  })
}
variable "resource_group_details" {

  description = "Resource Group  "
  type        = object({
    name     = string
    location = string
  })
}