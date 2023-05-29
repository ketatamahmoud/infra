resource "tls_private_key" "linux_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
locals {
  source_file      = join("/", [var.local_source_folder_path, var.install_script_name])
  destination_file = join("/", ["/home", var.vm_details.admin_username, var.install_script_name])
  azurerm_managed_disk_name = format("%s_%s_%s", var.resource_group_details.name, var.env, "datadisk")
}
resource "local_file" "linuxkey" {
  filename = format("%s/%s_%s_%s%s",var.vm_details.path_linux_key, var.resource_group_details.name, var.env, "linux_key", ".pem")
  content  = tls_private_key.linux_ssh_key.private_key_pem
}
locals {
  vm_name = format("%s%d", var.env, random_integer.random_num.result)
}

resource "random_integer" "random_num" {
  min = 0
  max = 99
}
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = local.vm_name
  resource_group_name   = var.resource_group_details.name
  location              = var.resource_group_details.location
  size                  = var.vm_details.size
  network_interface_ids = var.network_interface_ids
  admin_username        = var.vm_details.admin_username


  admin_ssh_key {
    username   = var.vm_details.admin_username
    public_key = tls_private_key.linux_ssh_key.public_key_openssh
  }


  os_disk {
    caching              = var.vm_details.os.caching
    storage_account_type = var.vm_details.os.storage_account_type

  }
  source_image_reference {
    publisher = var.vm_details.source_image_reference.publisher
    offer     = var.vm_details.source_image_reference.offer
    sku       = var.vm_details.source_image_reference.sku
    version   = var.vm_details.source_image_reference.version
  }

  connection {
    type        = "ssh"
    user        = var.vm_details.admin_username
    host        = self.public_ip_address
    private_key = file(local_file.linuxkey.filename)
  }
  #    provisioner "file" {
  #      source      = var.install_script_path
  #      destination = "/home/adminuser/script.sh"
  #    }





  provisioner "file" {
    source      = local.source_file
    destination = local.destination_file
    connection {
      type        = "ssh"
      user        = var.vm_details.admin_username
      host        = self.public_ip_address
      private_key = file(local_file.linuxkey.filename)
    }
  }


  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x ${local.destination_file}",
      "sudo ./${var.install_script_name} ${var.script_arguments}",
    ]
    connection {
      type        = "ssh"
      user        = var.vm_details.admin_username
      private_key = file(local_file.linuxkey.filename)
      host        = self.public_ip_address
    }
  }

}



resource "azurerm_managed_disk" "example" {
  name                 = local.azurerm_managed_disk_name
  location             = var.resource_group_details.location
  resource_group_name  = var.resource_group_details.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "100"
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = "0"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "example" {
  name                 = "your-vm-extension-name"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
depends_on = [azurerm_virtual_machine_data_disk_attachment.example]
}