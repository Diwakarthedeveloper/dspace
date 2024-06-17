

# provider "azurerm" {
#   features {}
# }



resource "azurerm_virtual_network" "djnet" {
  name                = "dj-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.djgrp.location
  resource_group_name = azurerm_resource_group.djgrp.name
}

resource "azurerm_subnet" "djsubnet" {
  name                 = "djinternalsubnet"
  resource_group_name  = azurerm_resource_group.djgrp.name
  virtual_network_name = azurerm_virtual_network.djnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "djpublicip" {
  name                = "dj-public-ip"
  location            = azurerm_resource_group.djgrp.location
  resource_group_name = azurerm_resource_group.djgrp.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "djnsg" {
  name                = "dj-nsg"
  location            = azurerm_resource_group.djgrp.location
  resource_group_name = azurerm_resource_group.djgrp.name

  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "djnsg_association" {
  network_interface_id      = azurerm_network_interface.djnetint.id
  network_security_group_id = azurerm_network_security_group.djnsg.id
}


resource "azurerm_network_interface" "djnetint" {
  name                = "dj-nic"
  location            = azurerm_resource_group.djgrp.location
  resource_group_name = azurerm_resource_group.djgrp.name



  ip_configuration {
    name                          = "djinternalip"
    subnet_id                     = azurerm_subnet.djsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.djpublicip.id
  }
}
###########
# Data source for Key Vault
data "azurerm_key_vault" "dj_kv" {
  name                = "djKeyVault2"
  resource_group_name = "dj-keyvault-rg"
}

# Data source for the secret ..
data "azurerm_key_vault_secret" "admin_password" {
  name         = "adminPassword"
  key_vault_id = data.azurerm_key_vault.dj_kv.id
}

###########

resource "azurerm_windows_virtual_machine" "djwvm" {
  name                = "dj-machine"
  resource_group_name = azurerm_resource_group.djgrp.name
  location            = azurerm_resource_group.djgrp.location
  size                = "Standard_F2"
  # admin_username      = "azureuser"
  # admin_password      = data.azurerm_key_vault_secret.admin_password.value
  network_interface_ids = [
    azurerm_network_interface.djnetint.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  admin_username = "azureuser"
  admin_password = data.azurerm_key_vault_secret.admin_password.value


}