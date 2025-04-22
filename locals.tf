# Local values to define branch policy scope and project details
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