terraform {
  required_version = ">= 1.9"
  backend "azurerm" {
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

# Data block to fetch details of the Azure DevOps project by its name
data "azuredevops_project" "this" {
  name = "example"
}

# Data block to fetch all Git repositories within the specified Azure DevOps project
data "azuredevops_git_repositories" "all" {
  project_id = data.azuredevops_project.this.id
}

module "azdo_branch_protection" {
  source = "../.."

  project_id   = data.azuredevops_project.this.id
  repositories = data.azuredevops_git_repositories.all.repositories

  branch_policy_auto_reviewers = {
    enabled            = true
    blocking           = true
    submitter_can_vote = false
    group_names        = ["group name"]
    message            = "Code Reviewers have been automatically assigned to this pull request"

  }

  branch_policy_min_reviewers = {
    reviewer_count                         = 1
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = true
    on_last_iteration_require_vote         = true
  }

  branch_policy_comment_resolution = {
    enabled  = true
    blocking = true
  }

  branch_policy_merge_types = {
    enabled                       = true
    blocking                      = true
    allow_squash                  = true
    allow_rebase_and_fast_forward = true
    allow_basic_no_fast_forward   = false
    allow_rebase_with_merge       = false
  }

  branch_policy_build_validation = {
    enabled                     = true
    blocking                    = false
    valid_duration              = 0
    manual_queue_only           = false
    queue_on_source_update_only = false
    suffix                      = "branch-validate"
  }
}