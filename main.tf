# ----------------------------------------------------------------------------------------
# Azure DevOps Branch Protection Policies
#
# DESCRIPTION
# This module can be used to enable/ configure branch protection policies on Azure DevOps.
# ----------------------------------------------------------------------------------------

# Data block to fetch details of the Azure DevOps project by its name
#data "azuredevops_project" "this" {
#  name = var.project_name
#}
#
## Data block to fetch all Git repositories within the specified Azure DevOps project
#data "azuredevops_git_repositories" "all" {
#  project_id = data.azuredevops_project.this.id
#}

# Local values to define branch policy scope and project details
locals {
  branch_policy_scope = {
    for repo in var.repositories :
    repo.name => {
      repository_id  = repo.id
      repository_ref = repo.default_branch
      match_type     = "Exact"
    }
  }
  azuredevops_project = try(data.azuredevops_project.this, data.azuredevops_project.this)
}

# Resource to configure minimum reviewers policy for branch protection
resource "azuredevops_branch_policy_min_reviewers" "this" {
  for_each = (
    var.branch_policy_min_reviewers != null &&
    try(var.branch_policy_min_reviewers.reviewer_count, null) != null
  ) ? local.branch_policy_scope : {}

  project_id = var.project_id

  settings {
    reviewer_count                         = var.branch_policy_min_reviewers.reviewer_count
    submitter_can_vote                     = var.branch_policy_min_reviewers.submitter_can_vote
    last_pusher_cannot_approve             = var.branch_policy_min_reviewers.last_pusher_cannot_approve
    allow_completion_with_rejects_or_waits = var.branch_policy_min_reviewers.allow_completion_with_rejects_or_waits
    on_last_iteration_require_vote         = var.branch_policy_min_reviewers.on_last_iteration_require_vote

    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

# Resource to enforce work item linking policy for branch protection
resource "azuredevops_branch_policy_work_item_linking" "this" {
  project_id = var.project_id
  for_each   = local.branch_policy_scope

  enabled  = var.branch_policy_work_item_linking.enabled
  blocking = var.branch_policy_work_item_linking.blocking

  settings {
    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

# Resource to enforce comment resolution policy for branch protection
resource "azuredevops_branch_policy_comment_resolution" "this" {
  project_id = var.project_id
  for_each   = local.branch_policy_scope

  enabled  = var.branch_policy_comment_resolution.enabled
  blocking = var.branch_policy_comment_resolution.blocking

  settings {
    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

# Resource to configure allowed merge types for branch protection
resource "azuredevops_branch_policy_merge_types" "this" {
  project_id = var.project_id
  for_each   = local.branch_policy_scope

  enabled  = var.branch_policy_merge_types.enabled
  blocking = var.branch_policy_merge_types.blocking

  settings {
    allow_squash                  = var.branch_policy_merge_types.allow_squash
    allow_rebase_and_fast_forward = var.branch_policy_merge_types.allow_rebase_and_fast_forward
    allow_basic_no_fast_forward   = var.branch_policy_merge_types.allow_basic_no_fast_forward
    allow_rebase_with_merge       = var.branch_policy_merge_types.allow_rebase_with_merge

    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

# Data block to fetch Azure DevOps group details by group names
data "azuredevops_group" "this" {
  for_each   = length(var.branch_policy_auto_reviewers.group_names) > 0 ? toset(var.branch_policy_auto_reviewers.group_names) : toset([])
  project_id = var.project_id
  name       = each.key
}

# Resource to configure auto reviewers policy for branch protection
resource "azuredevops_branch_policy_auto_reviewers" "this" {
  for_each = length(var.branch_policy_auto_reviewers.group_names) > 0 ? local.branch_policy_scope : {}

  project_id = var.project_id
  enabled    = var.branch_policy_auto_reviewers.enabled
  blocking   = var.branch_policy_auto_reviewers.blocking

  settings {
    auto_reviewer_ids  = [for group in data.azuredevops_group.this : group.origin_id]
    submitter_can_vote = var.branch_policy_auto_reviewers.submitter_can_vote
    message            = var.branch_policy_auto_reviewers.message

    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

# Data block to fetch build definition details for build validation policy
data "azuredevops_build_definition" "build_definition" {
  project_id = var.project_id
  for_each = {
    for k, v in local.branch_policy_scope :
    k => v if var.branch_policy_build_validation.suffix != "" && v != null
  }
  name = "${each.key}-${var.branch_policy_build_validation.suffix}"
}

# Resource to configure build validation policy for branch protection
resource "azuredevops_branch_policy_build_validation" "this" {
  for_each = {
    for k, v in local.branch_policy_scope :
    k => v if var.branch_policy_build_validation.suffix != "" &&
    try(data.azuredevops_build_definition.build_definition[k], null) != null
  }
  project_id = var.project_id

  enabled  = var.branch_policy_build_validation.enabled
  blocking = var.branch_policy_build_validation.blocking

  settings {
    display_name                = data.azuredevops_build_definition.build_definition[each.key].name
    build_definition_id         = data.azuredevops_build_definition.build_definition[each.key].id
    valid_duration              = var.branch_policy_build_validation.valid_duration
    manual_queue_only           = var.branch_policy_build_validation.manual_queue_only
    queue_on_source_update_only = var.branch_policy_build_validation.queue_on_source_update_only

    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

