variable "resource_group_name" {
    type = string
}

variable "location" {
  type = string
}

variable "app_plan_capacity" {
  type = number
  default = 1
}

variable "app_service_plan_tier" {
  type = string
  default = "Standard"
}

variable "app_service_plan_tier_size" {
  type = string
  default = "S1"
}

# variable "image_build" {
#   type = string
#   description = "Latest image build number"
# }

variable "tenant_id" {
  type = string
  description = "AAD tenant ID"
}

## The service principal requires access permission to create secrets in Key vault. Azure pipeline will use this service principal to run terraform
## how to find object_id of a service principal? command `az ad sp show --id <AAD_APPLICATION_ID>`
variable "service_principal_object_id" {
  type = string
  default = "3b2ced33-44a8-40a4-b2fd-421552a1215a"
}