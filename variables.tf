variable "name" {
  type        = string
  description = <<DESCRIPTION
The full name of the Workload.

Example:
  - 'Management'
  - 'Cloud Center of Excellence'
DESCRIPTION
}

variable "short_name" {
  type        = string
  description = <<DESCRIPTION
The short (4-letter) name for the Workload.

Example:
  - 'mgmt'
  - 'ccoe'

Validation:
  - The length of the short_name must be exactly 4 characters.
DESCRIPTION
  validation {
    condition     = length(var.short_name) == 4
    error_message = "The length of the short_name should be 4 characters"
  }
}

variable "location" {
  type        = string
  description = <<DESCRIPTION
The Azure Region where the Resource Groups and Managed Identities will be created.

Example:
  - 'East US'
  - 'West Europe'
DESCRIPTION
}

variable "azure_devops" {
  type = object({
    org          = string
    project_name = string
  })
  description = <<DESCRIPTION
Azure DevOps Configuration.

Example:
  azure_devops = {
    org          = "example" # Name of the Azure DevOps organization (e.g., 'example' when the Azure DevOps URL is https://dev.azure.com/example)
    project_name = "my-project" # Name of the project
  }
DESCRIPTION
}

variable "branch_policy_min_reviewers_settings" {
  description = <<DESCRIPTION
Optional settings for the branch policy minimum reviewers. If not provided, the policy will be skipped.

Fields:
  - reviewer_count (required): Number of required reviewers.
  - submitter_can_vote (optional): Whether the submitter can vote. Default is false.
  - last_pusher_cannot_approve (optional): Whether the last pusher can approve. Default is false.
  - allow_completion_with_rejects_or_waits (optional): Allow completion with rejects or waits. Default is false.
  - on_last_iteration_require_vote (optional): Require vote on the last iteration. Default is false.
DESCRIPTION
  type = object({
    reviewer_count                         = number
    submitter_can_vote                     = optional(bool, false)
    last_pusher_cannot_approve             = optional(bool, false)
    allow_completion_with_rejects_or_waits = optional(bool, false)
    on_last_iteration_require_vote         = optional(bool, false)
  })
  default = null
}

variable "azuredevops_branch_policy_work_item_linking" {
  description = <<DESCRIPTION
Optional settings for the branch policy work item linking.

Fields:
  - enabled (optional): Whether the policy is enabled. Default is false.
  - blocking (optional): Whether the policy is blocking. Default is false.
DESCRIPTION
  type = object({
    enabled  = optional(bool, false)
    blocking = optional(bool, false)
  })
  default = {
    enabled  = false
    blocking = false
  }
}

variable "azuredevops_branch_policy_comment_resolution" {
  description = <<DESCRIPTION
Optional settings for the branch policy comment resolution.

Fields:
  - enabled (optional): Whether the policy is enabled. Default is false.
  - blocking (optional): Whether the policy is blocking. Default is false.
DESCRIPTION
  type = object({
    enabled  = optional(bool, false)
    blocking = optional(bool, false)
  })
  default = {
    enabled  = false
    blocking = false
  }
}

variable "azuredevops_branch_policy_merge_types" {
  description = <<DESCRIPTION
Settings for Azure DevOps branch policy merge types.

Fields:
  - enabled (optional): Whether the policy is enabled. Default is false.
  - blocking (optional): Whether the policy is blocking. Default is false.
  - allow_squash (optional): Allow squash merges. Default is false.
  - allow_rebase_and_fast_forward (optional): Allow rebase and fast-forward merges. Default is false.
  - allow_basic_no_fast_forward (optional): Allow basic no fast-forward merges. Default is false.
  - allow_rebase_with_merge (optional): Allow rebase with merge. Default is false.
DESCRIPTION
  type = object({
    enabled                       = optional(bool, false)
    blocking                      = optional(bool, false)
    allow_squash                  = optional(bool, false)
    allow_rebase_and_fast_forward = optional(bool, false)
    allow_basic_no_fast_forward   = optional(bool, false)
    allow_rebase_with_merge       = optional(bool, false)
  })
  default = {
    enabled                       = false
    blocking                      = false
    allow_squash                  = false
    allow_rebase_and_fast_forward = false
    allow_basic_no_fast_forward   = false
    allow_rebase_with_merge       = false
  }
}

variable "azuredevops_branch_policy_auto_reviewers" {
  description = <<DESCRIPTION
Auto reviewer policy settings.

Fields:
  - enabled (required): Whether the policy is enabled.
  - blocking (required): Whether the policy is blocking.
  - group_names (required): List of group names to assign as reviewers.
  - submitter_can_vote (required): Whether the submitter can vote.
  - message (required): Message to display when reviewers are assigned.
  - minimum_number_of_reviewers (required): Minimum number of reviewers required.
DESCRIPTION
  type = object({
    enabled                     = optional(bool, false)
    blocking                    = optional(bool, false)
    group_names                 = list(string)
    submitter_can_vote          = optional(bool, false)
    message                     = optional(string, "Code Reviewers")
    minimum_number_of_reviewers = optional(number, 1)
  })
  default = {
    enabled                     = false
    blocking                    = false
    group_names                 = []
    submitter_can_vote          = false
    message                     = "Code Reviewers have been automatically assigned to this pull request."
    minimum_number_of_reviewers = 1
  }
}

variable "azuredevops_branch_policy_build_validation" {
  description = <<DESCRIPTION
Branch policy build validation settings.

Fields:
  - enabled (optional): Whether the policy is enabled. Default is false.
  - blocking (optional): Whether the policy is blocking. Default is false.
  - valid_duration (optional): Duration (in minutes) for which the build is valid. Default is 720.
  - manual_queue_only (optional): Whether the build must be manually queued. Default is false.
  - queue_on_source_update_only (optional): Queue builds only on source updates. Default is true.
  - suffix (optional): Suffix to append to the build policy name. Default is an empty string.
DESCRIPTION
  type = object({
    enabled                     = optional(bool, false)
    blocking                    = optional(bool, false)
    valid_duration              = optional(number, 720)
    manual_queue_only           = optional(bool, false)
    queue_on_source_update_only = optional(bool, true)
    suffix                      = optional(string, "")
  })
  default = {
    enabled                     = false
    blocking                    = false
    valid_duration              = 720
    manual_queue_only           = false
    queue_on_source_update_only = true
    suffix                      = ""
  }
}
