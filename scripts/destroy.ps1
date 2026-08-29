[CmdletBinding()]
param(
    [string]$Profile = "academy",
    [string]$VarFile = "terraform.tfvars"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$terraformDirectory = Join-Path $projectRoot "terraform"

$confirmation = Read-Host "Digite DESTRUIR para remover a EC2, VPC e todos os recursos deste projeto"
if ($confirmation -cne "DESTRUIR") {
    Write-Host "Operação cancelada. Nenhum recurso foi removido." -ForegroundColor Yellow
    exit 0
}

$env:AWS_PROFILE = $Profile
aws sts get-caller-identity --no-cli-pager | Out-Host

Push-Location $terraformDirectory
try {
    terraform init
    terraform destroy -var-file=$VarFile
}
finally {
    Pop-Location
}
