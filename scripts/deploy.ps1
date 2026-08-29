[CmdletBinding()]
param(
    [string]$Profile = "academy",
    [string]$VarFile = "terraform.tfvars"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$terraformDirectory = Join-Path $projectRoot "terraform"
$variableFilePath = Join-Path $terraformDirectory $VarFile

foreach ($commandName in @("aws", "terraform")) {
    if ($null -eq (Get-Command $commandName -ErrorAction SilentlyContinue)) {
        throw "Comando '$commandName' não encontrado. Execute scripts/verify-environment.ps1."
    }
}

if (-not (Test-Path $variableFilePath)) {
    throw "Arquivo $variableFilePath não encontrado. Copie terraform.tfvars.example para terraform.tfvars e informe sua imagem Docker."
}

$env:AWS_PROFILE = $Profile
Write-Host "Validando as credenciais temporárias do perfil '$Profile'..." -ForegroundColor Cyan
aws sts get-caller-identity --no-cli-pager | Out-Host

Push-Location $terraformDirectory
try {
    terraform init
    terraform fmt -check -recursive
    terraform validate
    terraform plan -var-file=$VarFile -out=tfplan

    Write-Host "Aplicando exatamente o plano exibido acima..." -ForegroundColor Yellow
    terraform apply tfplan

    $siteUrl = terraform output -raw site_url
    Write-Host "Aguardando o portal responder em $siteUrl ..." -ForegroundColor Cyan

    $ready = $false
    for ($attempt = 1; $attempt -le 30; $attempt++) {
        try {
            $response = Invoke-WebRequest -Uri $siteUrl -UseBasicParsing -TimeoutSec 5
            if ($response.StatusCode -eq 200) {
                $ready = $true
                break
            }
        }
        catch {
            Start-Sleep -Seconds 5
        }
    }

    if ($ready) {
        Write-Host "Portal disponível: $siteUrl" -ForegroundColor Green
    }
    else {
        Write-Warning "A EC2 foi criada, mas o portal ainda não respondeu. Consulte /var/log/cp04-bootstrap.log na instância."
    }

    terraform output
}
finally {
    Pop-Location
}
