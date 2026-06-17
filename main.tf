terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "4.73.0"
        }
    }
}
resource "azurerm_resource_group" "rg" {
    name = "rg32"
    location = "westus"
}
resource "azurerm_virtual_network" "vnet" {
    name = "vnet23"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space = ["10.0.0.0/24"]
}
resource "azurerm_subnet" "subnet" {
    name= "subnet23"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm-virtual-network.vnet.name
    address_prefixes = ["10.0.0.0/25"]
}
resource "azurerm_network_interface" "nic" {
    name = "nic32"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    ip_configuration {
        name = "ipconfig1"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        }
    }
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm32"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"

  admin_username = "azureuser"
  admin_password = "P@ssword1234"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}