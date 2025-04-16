data "azuredevops_project" "this" {
  name = var.azure_devops.project_name
}

data "azuredevops_git_repositories" "all" {
  project_id = data.azuredevops_project.this.id
}

locals {
  branch_policy_scope = {
    for repo in data.azuredevops_git_repositories.all.repositories :
    repo.name => {
      repository_id  = repo.id
      repository_ref = repo.default_branch
      match_type     = "Exact"
    }
  }
  azuredevops_project = try(data.azuredevops_project.this, data.azuredevops_project.this)
}

resource "azuredevops_branch_policy_min_reviewers" "this" {
  for_each = (
    var.branch_policy_min_reviewers_settings != null &&
    try(var.branch_policy_min_reviewers_settings.reviewer_count, null) != null
  ) ? local.branch_policy_scope : {}

  project_id = local.azuredevops_project.id

  settings {
    reviewer_count                         = var.branch_policy_min_reviewers_settings.reviewer_count
    submitter_can_vote                     = var.branch_policy_min_reviewers_settings.submitter_can_vote
    last_pusher_cannot_approve             = var.branch_policy_min_reviewers_settings.last_pusher_cannot_approve
    allow_completion_with_rejects_or_waits = var.branch_policy_min_reviewers_settings.allow_completion_with_rejects_or_waits
    #on_push_reset_approved_votes           = var.branch_policy_min_reviewers_settings.on_push_reset_approved_votes
    on_last_iteration_require_vote         = var.branch_policy_min_reviewers_settings.on_last_iteration_require_vote
    #on_push_reset_all_votes                = var.branch_policy_min_reviewers_settings.on_push_reset_all_votes

    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

resource "azuredevops_branch_policy_work_item_linking" "this" {
  
  project_id = local.azuredevops_project.id
  for_each   = local.branch_policy_scope

  enabled  = var.azuredevops_branch_policy_work_item_linking.enabled
  blocking = var.azuredevops_branch_policy_work_item_linking.blocking

  settings {
    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

resource "azuredevops_branch_policy_comment_resolution" "this" {
  project_id = local.azuredevops_project.id
  for_each   = local.branch_policy_scope

  enabled  = var.azuredevops_branch_policy_comment_resolution.enabled
  blocking = var.azuredevops_branch_policy_comment_resolution.blocking

  settings {
    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

resource "azuredevops_branch_policy_merge_types" "this" {
  project_id = local.azuredevops_project.id
  for_each   = local.branch_policy_scope

  enabled  = var.azuredevops_branch_policy_merge_types.enabled
  blocking = var.azuredevops_branch_policy_merge_types.blocking

  settings {
    allow_squash                  = var.azuredevops_branch_policy_merge_types.allow_squash
    allow_rebase_and_fast_forward = var.azuredevops_branch_policy_merge_types.allow_rebase_and_fast_forward
    allow_basic_no_fast_forward   = var.azuredevops_branch_policy_merge_types.allow_basic_no_fast_forward
    allow_rebase_with_merge       = var.azuredevops_branch_policy_merge_types.allow_rebase_with_merge

    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}
#
#data "azuredevops_group" "this" {
#  project_id = local.azuredevops_project.id
#  name       = "${var.short_name} Team"
#}
#
#resource "azuredevops_branch_policy_auto_reviewers" "this" {
#  project_id = local.azuredevops_project.id
#  for_each   = local.branch_policy_scope
#
#  enabled  = true
#  blocking = true
#
#  settings {
#    auto_reviewer_ids  = [data.azuredevops_group.this.origin_id]
#    submitter_can_vote = false
#    message            = "Code Reviewers have been automatically assigned to this pull request."
#
#    scope {
#      repository_id  = each.value.repository_id
#      repository_ref = each.value.repository_ref
#      match_type     = each.value.match_type
#    }
#  }
#}
#