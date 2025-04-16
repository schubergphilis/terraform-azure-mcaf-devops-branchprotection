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
    on_last_iteration_require_vote = var.branch_policy_min_reviewers_settings.on_last_iteration_require_vote
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

data "azuredevops_group" "this" {
  for_each   = length(var.azuredevops_branch_policy_auto_reviewers.group_names) > 0 ? toset(var.azuredevops_branch_policy_auto_reviewers.group_names) : toset([])
  project_id = local.azuredevops_project.id
  name       = each.key
}

resource "azuredevops_branch_policy_auto_reviewers" "this" {
  for_each = length(var.azuredevops_branch_policy_auto_reviewers.group_names) > 0 ? local.branch_policy_scope : {}

  project_id = local.azuredevops_project.id
  enabled    = var.azuredevops_branch_policy_auto_reviewers.enabled
  blocking   = var.azuredevops_branch_policy_auto_reviewers.blocking

  settings {
    auto_reviewer_ids  = [for group in data.azuredevops_group.this : group.origin_id]
    submitter_can_vote = var.azuredevops_branch_policy_auto_reviewers.submitter_can_vote
    message            = var.azuredevops_branch_policy_auto_reviewers.message

    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

data "azuredevops_build_definition" "build_definition" {
  project_id = local.azuredevops_project.id
  for_each   = local.branch_policy_scope
  name       = "${each.key}-branch-validate"
}


output "build_definition_ids" {
  value = {
    for k, v in data.azuredevops_build_definition.build_definition :
    k => v.id
  }
}
#resource "azuredevops_branch_policy_build_validation" "this" {
#  for_each   = local.branch_policy_scope
#  project_id = local.azuredevops_project.id
#
#  enabled  = var.azuredevops_branch_policy_build_validation.enabled
#  blocking = var.azuredevops_branch_policy_build_validation.blocking
#
#  settings {
#    display_name        = "Branch Validation"
#    build_definition_id = azuredevops_build_definition.build_definitions[count.index].id
#    valid_duration      = 720 # minutes => 12 hours
#
#    scope {
#      repository_id  = each.value.repository_id
#      repository_ref = each.value.repository_ref
#      match_type     = each.value.match_type
#    }
#  }
#
#  depends_on = [
#    azuredevops_git_repository_file.default_pipeline,
#    azuredevops_git_repository_file.default_gitignore,
#  ]
#}
