variable "allowed_repos_branches" {
  description = "GitHub repos/branches allowed to assume the IAM role"
  type = list(object({
    org     = string
    org_id  = string
    repo    = string
    repo_id = string
    branch  = string
  }))
}