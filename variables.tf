variable "name" {
  type        = string
  description = "The full name of the Workload, e.g. 'Management' or 'Cloud Center of Excellence'"
}

variable "short_name" {
  type        = string
  description = "The short (4 letter) name for the Workload, e.g. 'mgmt' or 'ccoe'"
  validation {
    condition     = length(var.short_name) == 4
    error_message = "The length of the short_name should be 4 characters"
  }
}

variable "location" {
  type        = string
  description = "The Azure Region where the Resource Groups and Managed Identities will be created"
}
variable "azure_devops" {
  type = object({
    org          = string
    project_name = string
  })
  description = <<DESCRIPTION

    "Azure Devops Configuration"

    ```
    azure_devops = {
      org = "Name of the azure devops organisation, e.g. 'example' when the Azure Devops URL is https://dev.azure.com/example"
      project_name = "Name of the project"
    }
    ```
DESCRIPTION
}

variable "branch_policy_min_reviewers_settings" {
  description = <<EOT
Optional settings for the branch policy minimum reviewers. If not provided, the policy will be skipped.
If provided, 'reviewer_count' is required.
EOT
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
  description = <<EOT
Optional settings for the branch policy work item linking.
EOT
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
  description = <<EOT
Optional settings for the branch policy comment resolution.
EOT
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
  description = "Settings for Azure DevOps branch policy merge types"
  type = object({
    enabled                       = optional(bool, false)
    blocking                      = optional(bool, false)
    allow_squash                  = optional(bool, false)
    allow_rebase_and_fast_forward = optional(bool, false)
    allow_basic_no_fast_forward   = optional(bool, false)
    allow_rebase_with_merge       = optional(bool, false)
  })
  default = {
    enabled  = false
    blocking = false
    allow_squash                  = false
    allow_rebase_and_fast_forward = false
    allow_basic_no_fast_forward   = false
    allow_rebase_with_merge       = false
  }
}

variable "azuredevops_branch_policy_auto_reviewers" {
  description = "Auto reviewer policy settings"
  type = object({
    enabled             = bool
    blocking            = bool
    group_names         = list(string)
    submitter_can_vote  = bool
    message             = string
    minimum_number_of_reviewers = number
  })
  default = {
    enabled            = false
    blocking           = false
    group_names        = []
    submitter_can_vote = false
    message            = "Code Reviewers have been automatically assigned to this pull request."
    minimum_number_of_reviewers = 1
  }
}

variable "azuredevops_branch_policy_build_validation" {
  description = "Branch policy build validation settings"
  type = object({
    enabled                      = optional(bool, false)
    blocking                     = optional(bool, false)
    valid_duration               = optional(number, 720)
    manual_queue_only            = optional(bool, false)
    queue_on_source_update_only  = optional(bool, true)
    suffix                      = optional(string, "")
  })
  default = {
    enabled            = false
    blocking           = false
    valid_duration     = 720
    manual_queue_only  = false
    queue_on_source_update_only = true
    suffix            = "build_validate"
  }
}