provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {resource = "joeudacity" }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {resource = "joeudacity" }
}

resource "azurerm_network_security_group" "main" {
	name = "${var.prefix}-nsg"
	location = var.location
	resource_group_name = azurerm_resource_group.main.name

	tags = {
		resource = "joeudacity"
	}
}

 resource "azurerm_network_security_rule" "main_allow" {
    	name = "${var.prefix}-allow"
    	priority = "100"
    	direction = "Inbound"
    	access = "Allow"
    	protocol = "TCP"
    	source_port_range = "*"
    	destination_port_range = "22"
    	source_address_prefix = "10.0.2.0/24"
    	destination_address_prefix = "*"
    	resource_group_name = azurerm_resource_group.main.name
    	network_security_group_name = azurerm_network_security_group.main.name
    }


resource "azurerm_network_security_rule" "main_deny" {
	name = "${var.prefix}-deny"
	priority = "200"
    	direction = "Inbound"
    	access = "Deny"
    	protocol = "TCP"
    	source_port_range = "*"
    	destination_port_range = "*"
    	source_address_prefix = "Internet"
    	destination_address_prefix = "*"
    	resource_group_name = azurerm_resource_group.main.name
    	network_security_group_name = azurerm_network_security_group.main.name
} 

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  count = var.vmcount
  name                = "${var.prefix}-nic${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
  	resource = "joeudacity"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-publicip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
    resource = "joeudacity"
   }
  }

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-loadbalancer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "${var.prefix}-frontendip"
    public_ip_address_id = azurerm_public_ip.main.id
  }
  tags = {
  	resource = "joeudacity"
  }
 }
resource "azurerm_lb_backend_address_pool" "main_pool" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.prefix}-main_pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count = var.vmcount
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main_pool.id
}

resource "azurerm_lb_probe" "main_probe" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "main_probe"
  port            = 22
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_lb_rule" "main_lb_rule" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "main_lb_rule"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "${var.prefix}-frontendip"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-avset"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    resource = "joeudacity"
  }
}

data "azurerm_image" "main" {
  name                = var.virtualimage
  resource_group_name = var.imagegroup
	
}

resource "azurerm_linux_virtual_machine" "main" {
  count = var.vmcount
  name                            = "${var.prefix}-vm${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  admin_username                  = var.admin
  admin_password                  = var.password
  disable_password_authentication = false
  source_image_id                 = data.azurerm_image.main.id
  availability_set_id             = azurerm_availability_set.main.id
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    }

   tags = {
   	resource = "joeudacity"
   	environemnt = "deploywebserver"
    }
  }

resource "azurerm_managed_disk" "main" {
  count = var.vmcount
  name                 = "${var.prefix}-mdisk${count.index}"
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {
    resource = "joeudacity"
  }
}