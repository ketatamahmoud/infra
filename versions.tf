terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.46.0"

    }

  }
  backend "local" {
    path = "terraform.tfstate"
  }

}

locals {
  string2 = "tfstate"
  storage_account_name = join("_", [var.resource_group_details.name, local.string2])
}
provider "azurerm" {
  features {
    virtual_machine_scale_set {
      roll_instances_when_required = true
      force_delete = true
      scale_to_zero_before_deletion = true
    }
  }
}