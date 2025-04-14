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
  count = try(var.branch_policy_min_reviewers_settings.reviewer_count, null) != null ? 1 : 0

  project_id = local.azuredevops_project.id
  for_each   = local.branch_policy_scope

  settings {
    reviewer_count                         = var.branch_policy_min_reviewers_settings.reviewer_count
    submitter_can_vote                     = try(var.branch_policy_min_reviewers_settings.submitter_can_vote, false)
    last_pusher_cannot_approve             = try(var.branch_policy_min_reviewers_settings.last_pusher_cannot_approve, true)
    allow_completion_with_rejects_or_waits = try(var.branch_policy_min_reviewers_settings.allow_completion_with_rejects_or_waits, false)
    on_push_reset_approved_votes           = try(var.branch_policy_min_reviewers_settings.on_push_reset_approved_votes, true)
    on_last_iteration_require_vote         = try(var.branch_policy_min_reviewers_settings.on_last_iteration_require_vote, true)

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

  enabled  = true
  blocking = false

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

  enabled  = true
  blocking = true

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

  enabled  = true
  blocking = true

  settings {
    allow_squash                  = true
    allow_rebase_and_fast_forward = true

    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}

data "azuredevops_group" "this" {
  project_id = local.azuredevops_project.id
  name       = "${var.short_name} Team"
}

resource "azuredevops_branch_policy_auto_reviewers" "this" {
  project_id = local.azuredevops_project.id
  for_each   = local.branch_policy_scope

  enabled  = true
  blocking = true

  settings {
    auto_reviewer_ids  = [data.azuredevops_group.this.origin_id]
    submitter_can_vote = false
    message            = "Code Reviewers have been automatically assigned to this pull request."

    scope {
      repository_id  = each.value.repository_id
      repository_ref = each.value.repository_ref
      match_type     = each.value.match_type
    }
  }
}
