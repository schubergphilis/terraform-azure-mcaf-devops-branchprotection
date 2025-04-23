# Output the Azure DevOps project details
output "azure_devops_project" {
  description = "Details of the Azure DevOps project."
  value       = var.project_id
}

# Output the list of repositories in the Azure DevOps project
output "azure_devops_repositories" {
  description = "List of repositories in the Azure DevOps project."
  value       = var.repositories
}

# Output the branch policy settings for each repository
output "branch_policy_settings" {
  description = "Branch policy settings for each repository."
  value = {
    min_reviewers = {
      for repo, settings in azuredevops_branch_policy_min_reviewers.this :
      repo => settings.settings
    }
    work_item_linking = {
      for repo, settings in azuredevops_branch_policy_work_item_linking.this :
      repo => settings.settings
    }
    comment_resolution = {
      for repo, settings in azuredevops_branch_policy_comment_resolution.this :
      repo => settings.settings
    }
    merge_types = {
      for repo, settings in azuredevops_branch_policy_merge_types.this :
      repo => settings.settings
    }
    auto_reviewers = {
      for repo, settings in azuredevops_branch_policy_auto_reviewers.this :
      repo => settings.settings
    }
    build_validation = {
      for repo, settings in azuredevops_branch_policy_build_validation.this :
      repo => settings.settings
    }
  }
}
