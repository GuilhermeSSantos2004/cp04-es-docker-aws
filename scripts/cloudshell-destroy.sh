#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="$(cd "$SCRIPT_DIR/../terraform" && pwd)"

export AWS_REGION="${AWS_REGION_NAME:-us-east-1}"
export AWS_DEFAULT_REGION="$AWS_REGION"
export PATH="$HOME/.local/bin:$PATH"
export TF_DATA_DIR="${TF_DATA_DIR:-/tmp/cp04-terraform-data}"
mkdir -p "$TF_DATA_DIR"

command -v aws >/dev/null 2>&1 || {
  echo "Comando 'aws' não encontrado." >&2
  exit 1
}

command -v terraform >/dev/null 2>&1 || {
  echo "Terraform não encontrado em $HOME/.local/bin." >&2
  exit 1
}

[[ -f "$TF_DIR/terraform.tfvars" ]] || {
  echo "Arquivo terraform/terraform.tfvars não encontrado." >&2
  exit 1
}

aws sts get-caller-identity --no-cli-pager \
  --query '{Account:Account,Arn:Arn}' \
  --output table

terraform -chdir="$TF_DIR" init -input=false
terraform -chdir="$TF_DIR" plan \
  -destroy \
  -input=false \
  -var-file=terraform.tfvars

read -r -p "Digite DESTRUIR para remover a EC2, VPC e a rede: " confirmation
if [[ "$confirmation" != "DESTRUIR" ]]; then
  echo "Operação cancelada. Nenhum recurso foi removido."
  exit 0
fi

terraform -chdir="$TF_DIR" destroy \
  -auto-approve \
  -input=false \
  -var-file=terraform.tfvars

echo "Recursos do projeto removidos."
