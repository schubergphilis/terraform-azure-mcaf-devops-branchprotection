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
    last_pusher_cannot_approve             = optional(bool, true)
    allow_completion_with_rejects_or_waits = optional(bool, false)
    on_push_reset_approved_votes           = optional(bool, false)
    on_last_iteration_require_vote         = optional(bool, true)
  })
  default = null
}