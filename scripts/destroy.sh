#!/usr/bin/env bash
set -euo pipefail

AWS_PROFILE_NAME="${AWS_PROFILE_NAME:-academy}"
TF_VAR_FILE="${TF_VAR_FILE:-terraform.tfvars}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="$(cd "$SCRIPT_DIR/../terraform" && pwd)"

read -r -p "Digite DESTRUIR para remover todos os recursos deste projeto: " confirmation
if [[ "$confirmation" != "DESTRUIR" ]]; then
  echo "Operação cancelada."
  exit 0
fi

export AWS_PROFILE="$AWS_PROFILE_NAME"
aws sts get-caller-identity --no-cli-pager

cd "$TF_DIR"
terraform init
terraform destroy -var-file="$TF_VAR_FILE"
