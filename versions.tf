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
  features {}
}