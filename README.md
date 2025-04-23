# terraform-azure-mcaf-devops-branchprotection
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 3, < 4 |
| <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4, < 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) | >= 1.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuredevops_branch_policy_auto_reviewers.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_auto_reviewers) | resource |
| [azuredevops_branch_policy_build_validation.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_build_validation) | resource |
| [azuredevops_branch_policy_comment_resolution.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_comment_resolution) | resource |
| [azuredevops_branch_policy_merge_types.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_merge_types) | resource |
| [azuredevops_branch_policy_min_reviewers.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_min_reviewers) | resource |
| [azuredevops_branch_policy_work_item_linking.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_work_item_linking) | resource |
| [azuredevops_build_definition.build_definition](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/build_definition) | data source |
| [azuredevops_git_repositories.all](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/git_repositories) | data source |
| [azuredevops_group.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/group) | data source |
| [azuredevops_project.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_devops"></a> [azure\_devops](#input\_azure\_devops) | Azure DevOps Configuration.<br/><br/>Example:<br/>  azure\_devops = {<br/>    org          = "example" # Name of the Azure DevOps organization (e.g., 'example' when the Azure DevOps URL is https://dev.azure.com/example)<br/>    project\_name = "my-project" # Name of the project<br/>  } | <pre>object({<br/>    org          = string<br/>    project_name = string<br/>  })</pre> | n/a | yes |
| <a name="input_branch_policy_auto_reviewers"></a> [branch\_policy\_auto\_reviewers](#input\_branch\_policy\_auto\_reviewers) | Auto reviewer policy settings.<br/><br/>Fields:<br/>  - enabled (required): Whether the policy is enabled.<br/>  - blocking (required): Whether the policy is blocking.<br/>  - group\_names (required): List of group names to assign as reviewers.<br/>  - submitter\_can\_vote (required): Whether the submitter can vote.<br/>  - message (required): Message to display when reviewers are assigned.<br/>  - minimum\_number\_of\_reviewers (required): Minimum number of reviewers required. | <pre>object({<br/>    enabled                     = optional(bool, false)<br/>    blocking                    = optional(bool, false)<br/>    group_names                 = list(string)<br/>    submitter_can_vote          = optional(bool, false)<br/>    message                     = optional(string, "Code Reviewers")<br/>    minimum_number_of_reviewers = optional(number, 1)<br/>  })</pre> | <pre>{<br/>  "blocking": false,<br/>  "enabled": false,<br/>  "group_names": [],<br/>  "message": "Code Reviewers have been automatically assigned to this pull request.",<br/>  "minimum_number_of_reviewers": 1,<br/>  "submitter_can_vote": false<br/>}</pre> | no |
| <a name="input_branch_policy_build_validation"></a> [branch\_policy\_build\_validation](#input\_branch\_policy\_build\_validation) | Branch policy build validation settings.<br/><br/>Fields:<br/>  - enabled (optional): Whether the policy is enabled. Default is false.<br/>  - blocking (optional): Whether the policy is blocking. Default is false.<br/>  - valid\_duration (optional): Duration (in minutes) for which the build is valid. Default is 720.<br/>  - manual\_queue\_only (optional): Whether the build must be manually queued. Default is false.<br/>  - queue\_on\_source\_update\_only (optional): Queue builds only on source updates. Default is true.<br/>  - suffix (optional): Suffix to append to the build policy name. Default is an empty string. | <pre>object({<br/>    enabled                     = optional(bool, false)<br/>    blocking                    = optional(bool, false)<br/>    valid_duration              = optional(number, 720)<br/>    manual_queue_only           = optional(bool, false)<br/>    queue_on_source_update_only = optional(bool, true)<br/>    suffix                      = optional(string, "")<br/>  })</pre> | <pre>{<br/>  "blocking": false,<br/>  "enabled": false,<br/>  "manual_queue_only": false,<br/>  "queue_on_source_update_only": true,<br/>  "suffix": "",<br/>  "valid_duration": 720<br/>}</pre> | no |
| <a name="input_branch_policy_comment_resolution"></a> [branch\_policy\_comment\_resolution](#input\_branch\_policy\_comment\_resolution) | Optional settings for the branch policy comment resolution.<br/><br/>Fields:<br/>  - enabled (optional): Whether the policy is enabled. Default is false.<br/>  - blocking (optional): Whether the policy is blocking. Default is false. | <pre>object({<br/>    enabled  = optional(bool, false)<br/>    blocking = optional(bool, false)<br/>  })</pre> | <pre>{<br/>  "blocking": false,<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_branch_policy_merge_types"></a> [branch\_policy\_merge\_types](#input\_branch\_policy\_merge\_types) | Settings for Azure DevOps branch policy merge types.<br/><br/>Fields:<br/>  - enabled (optional): Whether the policy is enabled. Default is false.<br/>  - blocking (optional): Whether the policy is blocking. Default is false.<br/>  - allow\_squash (optional): Allow squash merges. Default is false.<br/>  - allow\_rebase\_and\_fast\_forward (optional): Allow rebase and fast-forward merges. Default is false.<br/>  - allow\_basic\_no\_fast\_forward (optional): Allow basic no fast-forward merges. Default is false.<br/>  - allow\_rebase\_with\_merge (optional): Allow rebase with merge. Default is false. | <pre>object({<br/>    enabled                       = optional(bool, false)<br/>    blocking                      = optional(bool, false)<br/>    allow_squash                  = optional(bool, false)<br/>    allow_rebase_and_fast_forward = optional(bool, false)<br/>    allow_basic_no_fast_forward   = optional(bool, false)<br/>    allow_rebase_with_merge       = optional(bool, false)<br/>  })</pre> | <pre>{<br/>  "allow_basic_no_fast_forward": false,<br/>  "allow_rebase_and_fast_forward": false,<br/>  "allow_rebase_with_merge": false,<br/>  "allow_squash": false,<br/>  "blocking": false,<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_branch_policy_min_reviewers"></a> [branch\_policy\_min\_reviewers](#input\_branch\_policy\_min\_reviewers) | Optional settings for the branch policy minimum reviewers. If not provided, the policy will be skipped.<br/><br/>Fields:<br/>  - reviewer\_count (required): Number of required reviewers.<br/>  - submitter\_can\_vote (optional): Whether the submitter can vote. Default is false.<br/>  - last\_pusher\_cannot\_approve (optional): Whether the last pusher can approve. Default is false.<br/>  - allow\_completion\_with\_rejects\_or\_waits (optional): Allow completion with rejects or waits. Default is false.<br/>  - on\_last\_iteration\_require\_vote (optional): Require vote on the last iteration. Default is false. | <pre>object({<br/>    reviewer_count                         = number<br/>    submitter_can_vote                     = optional(bool, false)<br/>    last_pusher_cannot_approve             = optional(bool, false)<br/>    allow_completion_with_rejects_or_waits = optional(bool, false)<br/>    on_last_iteration_require_vote         = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_branch_policy_work_item_linking"></a> [branch\_policy\_work\_item\_linking](#input\_branch\_policy\_work\_item\_linking) | Optional settings for the branch policy work item linking.<br/><br/>Fields:<br/>  - enabled (optional): Whether the policy is enabled. Default is false.<br/>  - blocking (optional): Whether the policy is blocking. Default is false. | <pre>object({<br/>    enabled  = optional(bool, false)<br/>    blocking = optional(bool, false)<br/>  })</pre> | <pre>{<br/>  "blocking": false,<br/>  "enabled": false<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_devops_project"></a> [azure\_devops\_project](#output\_azure\_devops\_project) | Output the Azure DevOps project details |
| <a name="output_azure_devops_repositories"></a> [azure\_devops\_repositories](#output\_azure\_devops\_repositories) | Output the list of repositories in the Azure DevOps project |
| <a name="output_branch_policy_settings"></a> [branch\_policy\_settings](#output\_branch\_policy\_settings) | Output the branch policy settings for each repository |
<!-- END_TF_DOCS -->