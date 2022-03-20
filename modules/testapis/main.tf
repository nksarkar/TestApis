locals {
  app_service_plan_name   = "${var.resource_group_name}-sp"
  app_service_name        = "${replace(var.resource_group_name, "_", "-")}-app-svc"
  app_service_slot_name   = "deploy-slot"
}
resource "azurerm_app_service_plan" "tf_app_service_plan" {
  name                      = local.app_service_plan_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  kind                      = "Linux"
  reserved                  = true

  sku {
      capacity              = var.app_plan_capacity
      tier                  = var.app_service_plan_tier
      size                  = var.app_service_plan_tier_size 
  }
}

resource "azurerm_app_service" "tf_app_service"{
    name                    = local.app_service_name
    location                = var.location
    resource_group_name     = var.resource_group_name
    app_service_plan_id     = azurerm_app_service_plan.tf_app_service_plan.id
    client_affinity_enabled = false
    site_config {
      always_on = false
      # linux_fx_version = "DOCKER|nks33/testapis:${var.image_build}"# "DOCKER|arc01.azurecr.io/myapp:latest"
    # linux_fx_version = "DOCKER|appsvcsample/python-helloworld:latest"
    }
    app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = "30"
    # "DOCKER_REGISTRY_SERVER_URL"          = 
  }
}

resource "azurerm_app_service_slot" "tf_app_service_slot"{
    name                    = local.app_service_slot_name
    app_service_name        = local.app_service_name
    location                = var.location
    resource_group_name     = var.resource_group_name
    app_service_plan_id     = azurerm_app_service_plan.tf_app_service_plan.id
    client_affinity_enabled = false
    site_config {
      always_on = false
      # linux_fx_version = "DOCKER|nks33/testapis:${var.image_build}"# "DOCKER|arc01.azurecr.io/myapp:latest"
    # linux_fx_version = "DOCKER|appsvcsample/python-helloworld:latest"
    }
    app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = "30"
    # "DOCKER_REGISTRY_SERVER_URL"          = 
  }
}

output "azurerm_app_service_plan_tf_app_service_plan"{
    value = azurerm_app_service_plan.tf_app_service_plan.id
}