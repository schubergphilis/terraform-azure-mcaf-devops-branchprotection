variable "project_id" {
  type        = string
  description = "The ID of the Azure DevOps project."
}

variable "repositories" {
  type = list(object({
    id             = string
    name           = string
    default_branch = string
  }))
  description = <<DESCRIPTION
A list of repositories with their details.

Fields:
  - id (required): The unique identifier of the repository.
  - name (required): The name of the repository.
  - default_branch (required): The default branch of the repository.
DESCRIPTION
}

variable "branch_policy_min_reviewers" {
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

variable "branch_policy_work_item_linking" {
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

variable "branch_policy_comment_resolution" {
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

variable "branch_policy_merge_types" {
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

variable "branch_policy_auto_reviewers" {
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

variable "branch_policy_build_validation" {
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
