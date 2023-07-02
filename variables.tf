variable "rg_name" {
  type    = string
  description = "Resource group name in Azure"
}

variable "location" {
  type    = string
  description = "Resource group location in Azure"
}

variable "acr" {
  type    = string
  description = "Azure Container Registry name"
}