myrg_details = {
    rg1 = {
        name = "vaibhavrg1"
        location = "eastus"
    }
}
myvnet = {
    vnet2 = {
        name = "vaibhavvnet1"
        location = "eastus"
        resource_group_name = "rg1"
        address_space = ["10.0.0.0/24"]
    }
}
mysubnet = {
    subnet2 = {
        name = "vaibhavsubnet1"
        location = "eastus"
        virtual_network_name = "vnet2"
        resource_group_name = "rg1"
        address_prefixes = ["10.0.0.0/25"]
    }
}
mynic = {
    nic1 = {
        name = "vaibhavnic1"
        location = "eastus"
        resource_group_name = "rg1"
        ip_configuration = {
            name = "myipconfig"
            subnet_name = "subnet2"
            private_ip_address_allocation = "Static" 
        }
    }
}
mywindowsvm = {
    vm1 = {
        name = "windowvm"
        resource_group_name = "rg1"
        location = "eastus"
        size = "Standard_DS1_V2"

    admin_username = "azureuser1"
    admin_password = "P@ssword1234"
    network_interface_id = ["vaibhavnic1"]
    disable_password_authentication = false

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2022-datacenter-azure-edition"
        version   = "latest"
        }    
        }    
    }
}

nsg21 = {
    nsg12 = {
        name = "vaibhavnsg1"
        resource_group_name = "rg1"
        location = "eastus"

    security_rule {
        name = "AllowRDP"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Any"
        source_port_range = "*"
        destination_port_range = "3389"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }    
    }
    }
