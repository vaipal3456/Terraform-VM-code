resource "azurerm_resource_group" "practicerg" {
    for_each = var.myrg_details
    name = each.value.name
    location = each.value.location
}
resource "azurerm_virtual_network" "vnet" {
    for_each = var.myvnet
    name = each.value.name
    resource_group_name = azurerm_resource_group.practicerg[each.value.resource_group_name].name
    location = azurerm_resource_group.practicerg[each.value.resource_group_name].location
    address_space = each.value.address_space
}
resource "azurerm_subnet" "subnet" {
    for_each = var.mysubnet
    name = each.value.name
    virtual_network_name = azurerm_virtual_network.vnet[each.value.virtual_network_name].name
    resource_group_name = azurerm_resource_group.practicerg[each.value.resource_group_name].name
    address_prefixes = each.value.address_prefixes
}
resource "azurerm_network_interface" "nic1" {
    for_each = var.mynic
    name = each.value.name
    resource_group_name = azurerm_resource_group.practicerg[each.value.resource_group_name].name
    location = azurerm_resource_group.practicerg[each.value.resource_group_name].location
    
    dynamic "ip_configuration" {
        for_each = each.value.ip_configuration
        content {

        name = each.value.ip_configuration.name
        subnet_id = azurerm_subnet.subnet[each.value.subnet_name].id
        private_ip_address_allocation = each.value.ip_configuration.private_ip_address_allocation
    }
}
}

resource "azurerm_windows_virtual_machine" "mywindows" {
    for_each = var.mywindowsvm
    name = each.key
    resource_group_name = each.value.resource_group_name
    location = each.value.location
    size = each.value.size

    admin_username = each.value.admin_username
    admin_password = each.value.admin_password

     network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

   
    
    dynamic "os_disk" {
        for_each = each.value.os_disk
        content {
        caching = each.value.os_disk.caching
        storage_account_type = each.value.os_disk.storage_account_type
    }
    }
    dynamic "source_image_reference" {
        for_each = each.value.source_image_reference
        content {
        publisher = each.value.source_image_reference.publisher
        offer = each.value.source_image_reference.offer
        sku = each.value.source_image_reference.sku
        version = each.value.source_image_reference.version
    }
    }
}    

resource "azurerm_network_security_group" "nsg1" {
        for_each = var.nsg21
        name = each.key
        location = each.value.location
        resource_group_name = azurerm_resource_group[each.key].name

        dynamic "security_rule" {
            for_each = each.value.security_rule
            content {
            name = each.value.security_rule.name
            priority = each.value.securtiy_rule.priority
            direction = each.value.security.rule.direction
            access = each.value.security_rule.access
            protocol = each.value.securtiy_rule.protocol
            source_port_range = each.value.security_rule.source_port_range
            destination_port_range = each.value.security_rule.destination_port_range
            source_address_prefix = each.value.security_rule.source_address_prefix
            destination_address_prefix = each.value.security_rule.destination_address_prefix      
            
        }
    }
}    