terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4, < 5"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 1.6.0"
    }
  }
}
