terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4, < 5"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3, < 4"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 1.6.0"
    }
  }
}
