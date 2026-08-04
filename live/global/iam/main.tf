terraform {
  backend "s3" {
    bucket       = "yash-jagani-portfolio-terraform-state"
    key          = "global/iam/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-west-2"
}

locals {
  managed_policies = [
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/CloudFrontFullAccess",
    "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]
  unique_repos = distinct([
    for a in var.allowed_repos_branches :
    {
      org     = a.org
      org_id  = a.org_id
      repo    = a.repo
      repo_id = a.repo_id
    }
  ])
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    data.tls_certificate.github.certificates[0].sha1_fingerprint
  ]
}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "github_actions" {
  name               = "yash-jagani-portfolio-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = concat(
        [
          for a in var.allowed_repos_branches :
          "repo:${a["org"]}@${a["org_id"]}/${a["repo"]}@${a["repo_id"]}:ref:refs/heads/${a["branch"]}"
        ],
        [
          for a in local.unique_repos :
          "repo:${a["org"]}@${a["org_id"]}/${a["repo"]}@${a["repo_id"]}:pull_request"
        ]
      )
    }
  }
}

resource "aws_iam_role_policy_attachment" "managed_attachments" {
  for_each   = toset(local.managed_policies)
  role       = aws_iam_role.github_actions.name
  policy_arn = each.value
}