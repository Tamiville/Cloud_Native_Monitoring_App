resource "azurerm_resource_group" "rg_name" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr
  resource_group_name = azurerm_resource_group.rg_name.name
  location            = azurerm_resource_group.rg_name.location
  sku                 = "Premium"
  admin_enabled       = true

  georeplications {
    location                = "Central US"
    zone_redundancy_enabled = true
    tags                    = {}
  }
  georeplications {
    location                = "East US"
    zone_redundancy_enabled = true
    tags                    = {}
  }
}