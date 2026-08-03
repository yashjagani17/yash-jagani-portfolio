#!/bin/bash
set -euo pipefail

echo "terraform init & apply for live/global/s3/main.tf"
(cd live/global/s3 && terraform init -input=false && terraform apply -auto-approve)

echo "terraform init & apply for live/global/iam/main.tf"
(cd live/global/iam && terraform init -input=false && terraform apply -auto-approve)

echo "terraform init & apply for live/global/dns/main.tf"
(cd live/global/dns && terraform init -input=false && terraform apply -auto-approve)

(cd live/global/s3 && terraform output s3_bucket_arn)
(cd live/global/iam && terraform output github_actions_role_arn)
(cd live/global/dns && terraform output name_servers)