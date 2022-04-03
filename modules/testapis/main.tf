locals {
  app_service_plan_name   = "${var.resource_group_name}-sp"
  app_service_name        = "${replace(var.resource_group_name, "_", "-")}-app-svc"
  app_service_slot_name   = "deploy-slot"
  keyvault_name           = "${replace(var.resource_group_name, "_", "")}kv"
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
    identity {
      type = "SystemAssigned"
    }
    site_config {
      always_on = false
      # linux_fx_version = "DOCKER|nks33/testapis:${var.image_build}"# "DOCKER|arc01.azurecr.io/myapp:latest"
    # linux_fx_version = "DOCKER|appsvcsample/python-helloworld:latest"
    }
    app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = "30"
    # "Authentication__AccessToken" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.tf_key_vault.vault_uri}secrets/${azurerm_key_vault_secret.tf_keyvault_secret.name})"
    "Authentication__AccessToken" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.tf_key_vault.vault_uri}secrets/AccessToken)"
  }
}

resource "azurerm_app_service_slot" "tf_app_service_slot"{
    name                    = local.app_service_slot_name
    app_service_name        = local.app_service_name
    location                = var.location
    resource_group_name     = var.resource_group_name
    app_service_plan_id     = azurerm_app_service_plan.tf_app_service_plan.id
    client_affinity_enabled = false
    identity {
      type = "SystemAssigned"
    }
    site_config {
      always_on = false
      # linux_fx_version = "DOCKER|nks33/testapis:${var.image_build}"# "DOCKER|arc01.azurecr.io/myapp:latest"
    # linux_fx_version = "DOCKER|appsvcsample/python-helloworld:latest"
    }
    app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITES_CONTAINER_START_TIME_LIMIT" = "30"
    # "Authentication__AccessToken" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.tf_key_vault.vault_uri}secrets/${azurerm_key_vault_secret.tf_keyvault_secret.name})"
    "Authentication__AccessToken" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.tf_key_vault.vault_uri}secrets/AccessToken)"
  # }
  }
}

resource "azurerm_key_vault" "tf_key_vault" {
  name                        = local.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
  sku_name                    = "standard" 
}

## Assign read access to AppService System Managed Identity to read secret from Key vault from application
resource "azurerm_key_vault_access_policy" "tf_key_vault_managed_identity_accesspolicy" {
  key_vault_id = azurerm_key_vault.tf_key_vault.id
  tenant_id = var.tenant_id
  object_id = azurerm_app_service.tf_app_service.identity[0].principal_id

  secret_permissions = [
    "get",
  ]

  key_permissions = []
  storage_permissions = []
}

## Assign write access to Service principal to allow creating new secret in key vault. eg: tf_keyvault_secret
resource "azurerm_key_vault_access_policy" "tf_key_vault_service_principal_accesspolicy" {
  key_vault_id = azurerm_key_vault.tf_key_vault.id
  tenant_id = var.tenant_id
  object_id = var.service_principal_object_id

  secret_permissions = [    
    "get",
    "list",
    "set"
   ]

  key_permissions = []
  storage_permissions = []
}

resource "azurerm_key_vault_secret" "tf_keyvault_secret" {
  name         = "AccessToken"
  value        = ""
  key_vault_id = azurerm_key_vault.tf_key_vault.id
}

output "azurerm_app_service_plan_tf_app_service_plan"{
    value = azurerm_app_service_plan.tf_app_service_plan.id
}