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

variable "image_build" {
  type = string
  description = "Latest image build number"
}