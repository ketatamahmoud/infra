
locals {
  script_arguments= {
    businessGroupId=var.business_group_id
    client_id=var.anypoint_client_id
    client_secret=var.anypoint_client_secret
    envName="ppd"
    nexusBaseAuth=var.nexusBaseAuth
    serverName=var.server_name
  }
}

resource "azurerm_resource_group" "example" {
  name     = "MuleSoft-Rg"
  location = var.resource_group_details.location
}
resource "tls_private_key" "linux_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "linuxkey" {
  filename = format("%s%s", "linux_key", ".pem")
  content  = tls_private_key.linux_ssh_key.private_key_pem
}
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_public_ip" "example" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "example" {
  name                = "LoadBalancer"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }

}
resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "backendpool"
}



resource "azurerm_availability_set" "app_set" {
  name                = "app-set"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  platform_fault_domain_count = 3
  platform_update_domain_count = 3
  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_storage_account" "appstore" {
  name                     = "installsh4577685m"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on=[
    azurerm_resource_group.example
  ]
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "installsh4577685m"
  container_access_type = "blob"
  depends_on=[
    azurerm_storage_account.appstore
  ]
}

# Here we are uploading our IIS Configuration script as a blob
# to the Azure storage account

resource "azurerm_storage_blob" "install" {
  name                   = "install.sh"
    storage_account_name   = "installsh4577685m"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "local_source_folder/install.sh"
  depends_on=[azurerm_storage_container.data]
}
#data "azurerm_storage_account_sas" "example" {
#  connection_string = azurerm_storage_account.appstore.primary_connection_string
#  start             = "2023-03-21"
#  expiry            = "2024-03-21"
#
#  resource_types {
#    service   = true
#    container = false
#    object    = true
#  }
#
#  services {
#    blob  = true
#    queue = false
#    table = false
#    file  = false
#  }
#
#  permissions {
#    read    = true
#    write   = false
#    delete  = false
#    list    = false
#    add     = false
#    create  = false
#    update  = false
#    process = false
#    filter  = false
#    tag     = false
#  }
#}

#resource "azurerm_virtual_machine_scale_set_extension" "custom_script_extension" {
#  name                 = "customScript"
#  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.example.id
#  publisher            = "Microsoft.Azure.Extensions"
#  type                 = "CustomScript"
#  type_handler_version = "2.1"
#
#  settings = <<SETTINGS
#    {
#      "fileUris": ["https://installsh4577685m.blob.core.windows.net/data/install.sh"],
#      "commandToExecute": "for i in `seq 1 ${azurerm_linux_virtual_machine_scale_set.example.instances}`; do az vmss run-command invoke -g ${azurerm_resource_group.example.name} -n ${azurerm_linux_virtual_machine_scale_set.example.name} --command-id RunShellScript --scripts 'curl -o script.sh https://installsh4577685m.blob.core.windows.net/data/install.sh && chmod +x script.sh && ./script.sh ${local.script_arguments}'; done"
#    }
#  SETTINGS
#
#  depends_on = [
#azurerm_linux_virtual_machine_scale_set.example  ]
#}



resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.example.id,
  ]
}
resource "azurerm_lb_rule" "ssh" {
    loadbalancer_id                = azurerm_lb.example.id
    name                           = "ssh"
    protocol                       = "Tcp"
    frontend_port                  = 22
    backend_port                   = 22
    frontend_ip_configuration_name = "PublicIPAddress"
    backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.example.id,
    ]
}
data "local_file" "install_sh" {
  filename = "${path.module}/local_source_folder/install.sh"
}
resource "azurerm_network_security_group" "example" {
  name                = "nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet_network_security_group_association" "vm_nsg_association" {

  subnet_id = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.example.id
  depends_on                = [
    azurerm_subnet.internal,

    azurerm_network_security_group.example
  ]
}


resource "azurerm_network_security_rule" "example2" {
  name                        = "outbound-allow-443"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}
resource "azurerm_network_security_rule" "example" {
  name                        = "AllowMulePorts"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080-8084"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}
resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "ppd-vmss"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard_B2ms"

  instances           = 2
  admin_username      = "mahmoud"
  user_data = base64encode(templatefile("${path.module}/userData.tftpl", local.script_arguments))

  admin_ssh_key {
    username   = "mahmoud"
    public_key = tls_private_key.linux_ssh_key.public_key_openssh
  }

  source_image_reference {
    publisher = "Canonical"

    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

#  extension {
#    name                 = "customScript"
#    publisher            = "Microsoft.Azure.Extensions"
#    type                 = "CustomScript"
#    type_handler_version = "2.0"
#    settings = jsonencode({
#      "fileUris": ["https://installsh4577685m.blob.core.windows.net/data/install.sh"],
#      "commandToExecute" = "/bin/bash  install.sh ${local.script_arguments}"
#    })
#  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.internal.id

      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.example.id]

    }

  }




}
#resource "azurerm_virtual_machine_scale_set_extension" "example" {
#  name                         = "example"
#  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.example.id
#  publisher                    = "Microsoft.Azure.Extensions"
#  type                         = "CustomScript"
#  type_handler_version         = "2.0"
#
#  settings = jsonencode({
#    "fileUris": ["https://installsh4577685m.blob.core.windows.net/data/install.sh"],
#    "commandToExecute" = "/bin/bash  install.sh ${local.script_arguments}"
#  })
#}

resource "azurerm_monitor_autoscale_setting" "example" {
  name                = "PPD-AutoscaleSetting"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.example.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.example.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.example.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["mahmoud.ketata@olivesoft.fr"]
    }
  }
}