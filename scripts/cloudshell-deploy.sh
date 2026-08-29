#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TF_DIR="$PROJECT_ROOT/terraform"

AWS_REGION_NAME="${AWS_REGION_NAME:-us-east-1}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.16.0}"
DOCKERHUB_USER="${1:-}"
DOCKER_REPOSITORY="cp04-site"
TEST_CONTAINER="cp04-cloudshell-test"
TEMP_DIR=""
DOCKER_LOGGED_IN=0

cleanup() {
  docker rm -f "$TEST_CONTAINER" >/dev/null 2>&1 || true

  if [[ "$DOCKER_LOGGED_IN" == "1" ]]; then
    docker logout >/dev/null 2>&1 || true
  fi

  if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
    rm -rf -- "$TEMP_DIR"
  fi
}
trap cleanup EXIT

fail() {
  echo "ERRO: $*" >&2
  exit 1
}

for command_name in aws git docker curl unzip sha256sum; do
  command -v "$command_name" >/dev/null 2>&1 || fail "Comando '$command_name' não encontrado no CloudShell."
done

if [[ -z "$DOCKERHUB_USER" ]]; then
  read -r -p "Digite somente seu usuário do Docker Hub: " DOCKERHUB_USER
fi

[[ "$DOCKERHUB_USER" =~ ^[a-z0-9][a-z0-9_-]+$ ]] || \
  fail "Nome de usuário do Docker Hub inválido. Use letras minúsculas, números, hífen ou sublinhado."

DOCKER_IMAGE="$DOCKERHUB_USER/$DOCKER_REPOSITORY:cp04"

export AWS_REGION="$AWS_REGION_NAME"
export AWS_DEFAULT_REGION="$AWS_REGION_NAME"
export PATH="$HOME/.local/bin:$PATH"
export TF_DATA_DIR="${TF_DATA_DIR:-/tmp/cp04-terraform-data}"
mkdir -p "$TF_DATA_DIR"

echo
echo "== 1/7 - Validando a sessão AWS do CloudShell =="
aws sts get-caller-identity --no-cli-pager \
  --query '{Account:Account,Arn:Arn}' \
  --output table

echo
echo "== 2/7 - Construindo e testando a imagem Docker =="
docker build --tag "$DOCKER_IMAGE" "$PROJECT_ROOT"
docker rm -f "$TEST_CONTAINER" >/dev/null 2>&1 || true
docker run --detach \
  --name "$TEST_CONTAINER" \
  --publish 8080:80 \
  "$DOCKER_IMAGE" >/dev/null

portal_ready=0
for attempt in $(seq 1 20); do
  if portal_content="$(curl --fail --silent http://127.0.0.1:8080/)" && \
    grep -q "Guilherme Silva dos Santos" <<<"$portal_content"; then
    portal_ready=1
    break
  fi
  sleep 1
done

[[ "$portal_ready" == "1" ]] || {
  docker logs "$TEST_CONTAINER"
  fail "O container local não respondeu corretamente."
}

docker image ls "$DOCKERHUB_USER/$DOCKER_REPOSITORY"
docker ps --filter "name=$TEST_CONTAINER"
echo "Teste local aprovado em http://127.0.0.1:8080/."

echo
echo "== 3/7 - Publicando a imagem no Docker Hub =="
echo "O Docker solicitará seu access token. O texto digitado não aparecerá na tela."
docker login --username "$DOCKERHUB_USER"
DOCKER_LOGGED_IN=1
docker push "$DOCKER_IMAGE"
docker logout >/dev/null 2>&1 || true
DOCKER_LOGGED_IN=0

image_public=0
for attempt in $(seq 1 10); do
  if curl --fail --silent \
    "https://hub.docker.com/v2/namespaces/$DOCKERHUB_USER/repositories/$DOCKER_REPOSITORY/tags/cp04" \
    >/dev/null; then
    image_public=1
    break
  fi
  sleep 2
done

[[ "$image_public" == "1" ]] || \
  fail "A tag foi enviada, mas não está publicamente acessível. Confirme que o repositório cp04-site está como Public no Docker Hub."

echo "Imagem pública confirmada: $DOCKER_IMAGE"

echo
echo "== 4/7 - Preparando o Terraform =="
if ! command -v terraform >/dev/null 2>&1; then
  case "$(uname -m)" in
    x86_64) terraform_arch="amd64" ;;
    aarch64|arm64) terraform_arch="arm64" ;;
    *) fail "Arquitetura não suportada para instalar o Terraform: $(uname -m)" ;;
  esac

  TEMP_DIR="$(mktemp -d)"
  terraform_zip="terraform_${TERRAFORM_VERSION}_linux_${terraform_arch}.zip"
  terraform_url="https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION"

  curl --fail --silent --show-error --location \
    "$terraform_url/$terraform_zip" \
    --output "$TEMP_DIR/$terraform_zip"
  curl --fail --silent --show-error --location \
    "$terraform_url/terraform_${TERRAFORM_VERSION}_SHA256SUMS" \
    --output "$TEMP_DIR/SHA256SUMS"

  (
    cd "$TEMP_DIR"
    grep " $terraform_zip\$" SHA256SUMS | sha256sum --check -
    unzip -q "$terraform_zip"
  )

  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$TEMP_DIR/terraform" "$HOME/.local/bin/terraform"
fi

terraform version

printf '%s\n' \
  "aws_region   = \"$AWS_REGION_NAME\"" \
  'project_name = "cp04-es"' \
  'instance_type = "t2.micro"' \
  "docker_image = \"$DOCKER_IMAGE\"" \
  'key_name = null' \
  'ssh_allowed_cidr = null' \
  > "$TF_DIR/terraform.tfvars"

terraform -chdir="$TF_DIR" fmt terraform.tfvars

echo
echo "== 5/7 - Validando e planejando a infraestrutura =="
terraform -chdir="$TF_DIR" init -input=false
terraform -chdir="$TF_DIR" fmt -check -recursive
terraform -chdir="$TF_DIR" validate
terraform -chdir="$TF_DIR" plan \
  -input=false \
  -var-file=terraform.tfvars \
  -out=tfplan

echo
echo "O plano acima criará uma VPC, rede pública, regras HTTP e uma EC2 t2.micro."
read -r -p "Digite APLICAR para criar os recursos: " confirmation
if [[ "$confirmation" != "APLICAR" ]]; then
  echo "Aplicação cancelada. Nenhum recurso novo foi criado pelo Terraform."
  exit 0
fi

echo
echo "== 6/7 - Criando a infraestrutura =="
terraform -chdir="$TF_DIR" apply -input=false tfplan

SITE_URL="$(terraform -chdir="$TF_DIR" output -raw site_url)"

echo
echo "== 7/7 - Aguardando o portal público =="
site_ready=0
for attempt in $(seq 1 40); do
  if portal_content="$(curl --fail --silent "$SITE_URL")" && \
    grep -q "Guilherme Silva dos Santos" <<<"$portal_content"; then
    site_ready=1
    break
  fi
  echo "Tentativa $attempt/40: a EC2 ainda está inicializando..."
  sleep 5
done

terraform -chdir="$TF_DIR" output

if [[ "$site_ready" == "1" ]]; then
  echo
  echo "SUCESSO: portal disponível em $SITE_URL"
  echo "Registre os prints antes de destruir a infraestrutura."
  echo "Depois execute: ./scripts/cloudshell-destroy.sh"
else
  fail "A infraestrutura foi criada, mas o portal ainda não respondeu em $SITE_URL."
fi
