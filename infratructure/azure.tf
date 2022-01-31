locals {
  location = "australiaeast"
}
terraform {
  required_providers{
      azurerm = {
          source = "hashicorp/azurerm"
          version = "=2.91.0"
      }
  }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "tf_resource_group" {
  name                      = "test_api_rg"
  location                  = local.location
}

resource "azurerm_container_group" "tf_container_group" {
    name                    = "test_container_group"
    location                = azurerm_resource_group.tf_resource_group.location
    resource_group_name     = azurerm_resource_group.tf_resource_group.name

    ip_address_type = "public"
    dns_name_label =  "nks33"
    os_type =  "Linux"
    
    container {
    name   = "testapis"
    image  = "nks33/testapis"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}