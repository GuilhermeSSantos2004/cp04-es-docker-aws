#!/usr/bin/env bash
set -euo pipefail

AWS_PROFILE_NAME="${AWS_PROFILE_NAME:-academy}"
TF_VAR_FILE="${TF_VAR_FILE:-terraform.tfvars}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TF_DIR="$PROJECT_ROOT/terraform"

for command_name in aws terraform; do
  command -v "$command_name" >/dev/null 2>&1 || {
    echo "Comando '$command_name' não encontrado." >&2
    exit 1
  }
done

if [[ ! -f "$TF_DIR/$TF_VAR_FILE" ]]; then
  echo "Crie terraform/$TF_VAR_FILE a partir de terraform.tfvars.example." >&2
  exit 1
fi

export AWS_PROFILE="$AWS_PROFILE_NAME"
aws sts get-caller-identity --no-cli-pager

cd "$TF_DIR"
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -var-file="$TF_VAR_FILE" -out=tfplan
terraform apply tfplan

SITE_URL="$(terraform output -raw site_url)"
echo "Portal: $SITE_URL"

for _ in $(seq 1 30); do
  if curl --fail --silent "$SITE_URL" >/dev/null; then
    echo "Portal disponível."
    terraform output
    exit 0
  fi
  sleep 5
done

echo "A EC2 foi criada, mas o portal ainda não respondeu." >&2
terraform output
exit 1
