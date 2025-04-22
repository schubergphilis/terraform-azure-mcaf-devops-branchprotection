terraform {
  required_version = ">= 1.9"
  backend "azurerm" {
    tenant_id            = "64f67a41-925a-440b-bcc8-9873b0715571"
    subscription_id      = "3afadbde-4850-4cd3-81ad-ec1c44805fa9"
    resource_group_name  = "apgp01-ccoe-gwc-tfst-rsg"
    storage_account_name = "apgp01ccoegwctfststa"
    container_name       = "tfstate-workload-onboarding"
    key                  = "vhub/wrko.tfstate"
    use_azuread_auth     = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3"
    }

    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.6.0"
    }
  }
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/example"
}

provider "azuread" {
  use_oidc = true
}

module "azdo_branch_protection" {
  source = "../.."
  azure_devops = {
    org          = "example"
    project_name = "exampleproject"
  }
  name       = "example workload"
  short_name = "exmp"
  location   = "eastus"
  azuredevops_branch_policy_auto_reviewers = {
    enabled            = true
    blocking           = true
    submitter_can_vote = false
    group_names        = ["group name"]
    message            = "Code Reviewers have been automatically assigned to this pull request"

  }

  branch_policy_min_reviewers_settings = {
    reviewer_count                         = 1
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = true
    on_last_iteration_require_vote         = true
  }

  azuredevops_branch_policy_comment_resolution = {
    enabled  = true
    blocking = true
  }

  azuredevops_branch_policy_merge_types = {
    enabled                       = true
    blocking                      = true
    allow_squash                  = true
    allow_rebase_and_fast_forward = true
    allow_basic_no_fast_forward   = false
    allow_rebase_with_merge       = false
  }

  azuredevops_branch_policy_build_validation = {
    enabled                     = true
    blocking                    = false
    valid_duration              = 0
    manual_queue_only           = false
    queue_on_source_update_only = false
    suffix                      = "branch-validate"
  }
}




