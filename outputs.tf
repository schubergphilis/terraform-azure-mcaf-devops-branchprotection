# Output the Azure DevOps project details
output "azure_devops_project_id" {
  description = "Details of the Azure DevOps project."
  value       = var.project_id
}

# Output to display Azure DevOps repositories with their names and IDs
output "azure_devops_repositories" {
  value = {
    for repo in var.repositories :
    repo.name => repo.id
  }
  description = "A map of Azure DevOps repository names to their IDs."
}

# Output the branch policy settings for each repository
output "branch_policy_settings" {
  description = "A map of branch policy settings for each repository."
  value = {
    for repo, settings in local.branch_policy_scope :
    repo => {
      min_reviewers_settings = try(azuredevops_branch_policy_min_reviewers.this[repo].settings, null)
      work_item_linking      = try(azuredevops_branch_policy_work_item_linking.this[repo].settings, null)
      comment_resolution     = try(azuredevops_branch_policy_comment_resolution.this[repo].settings, null)
      merge_types            = try(azuredevops_branch_policy_merge_types.this[repo].settings, null)
      auto_reviewers         = try(azuredevops_branch_policy_auto_reviewers.this[repo].settings, null)
      build_validation       = try(azuredevops_branch_policy_build_validation.this[repo].settings, null)
    }
  }
}
    