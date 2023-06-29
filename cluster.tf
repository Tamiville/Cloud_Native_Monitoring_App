############## SERVICE PRINCIPAL SETUP  ############

data "azuread_client_config" "current" {}

resource "azuread_application" "flaskapp" {
  display_name = "flaskapp"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "flaskapp-sp" {
  application_id               = azuread_application.flaskapp.application_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "flaskapp-sp-pswd" {
  service_principal_id = azuread_service_principal.flaskapp-sp.object_id
}


# resource "azurerm_role_assignment" "rolespn" {
#   scope                = "/subscriptions/********-****-****-****-*******"
#   role_definition_name = "contributor"
#   principal_id         = azuread_service_principal_object_id

#   # depends_on = [
#   #   azuread_service_principal
#   #   ]
# }


##====================A*K*S========================##

# Datasource to get latest Azure AKS Latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location        = "North Europe"
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "flaskapp-aks-cluster"
  location            = azurerm_resource_group.flask_app_rg.location
  resource_group_name = azurerm_resource_group.flask_app_rg.name
  dns_prefix          = "k8stest"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version

  default_node_pool {
    name                = "defaultpool"
    vm_size             = "Standard_D2_V2"
    zones               = [1, 2]
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
    tags = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
  }

    service_principal {
      client_id     = azuread_service_principal.flaskapp-sp.application_id
      client_secret = azuread_service_principal_password.flaskapp-sp-pswd.value
    }


  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDoW3RXQi3KKcPidnCCnp+Gr3e1LfXCRrxFOAk2EjkbJGfY2RvmnpVGMCVg79dODfRSWQIJb+WVuSLqqwEGSrjtUvRNwdlipIQGiZ9gvf3BMy6cqAb27Owkcziz4iubeoG+qgSE2uX1jcl6Y3bHZs04c3iTdq6zZEm62lwGDbz3XB2f6Txr/jeiOoPH4Q0nyM8bjbcfUvuclSLnXCuO6dmJDBaTYZEVa/pY5gtVu7sy9MwNW/eMc0jJy1sMhVFKv7k2KtmyOUfLfZ/r+6JVOF1AakNZx61Z90o3RE8/0qaGkvShLRhinxcjagsl3Lqmw0fl50Bf1xQlx8OOAqbB/pWaHTwwPYXSo6J/TXCZwS3npTUGgnTyX20zTH6WdGMhPxerq+PLTrnonrmG1Yj5vVQJI43WfzOksPzBHaj0OEyF+T5PiDzpZDR4PROOqPrpcPTGn4irJvP0STo7YbW1Zuzto+dIUINd4MtNeQfzpLj/MHNMucL8JOxDQfdHV4MPoIQPHe6FdY+OIJJsnzx/D7+mH2y9dD72kGARxOaVF9XsEHwCQRsfRL9TS64GCSAKYinpc/9ij0H7Y4Q7jqLIakZgmwHJUnvO6ByMjOSYTq5qK52TcV+To9Hvj4xJcanvs7YS+jcnWzM8rIw4GdaC4dmECEA8VVUE6Pg9qMQMk6Sk1w== devopslab@Tamie-Emmanuel"
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}