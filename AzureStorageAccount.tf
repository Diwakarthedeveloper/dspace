resource "azurerm_resource_group" "djgrp" { // resource type - azurerm_resource_group, local name - djgrp
  name     = "dj-resources"
  location = "Central India"
}

##  Demo now
resource "azurerm_storage_account" "DjStorageAccount" {
  name                     = "Djstore"
  resource_group_name      = azurerm_resource_group.djgrp.name
  location                 = azurerm_resource_group.djgrp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}