[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$requiredCommands = @("git", "docker", "aws", "terraform")
$missingCommands = @()

Write-Host "Verificando ferramentas..." -ForegroundColor Cyan

foreach ($commandName in $requiredCommands) {
    $command = Get-Command $commandName -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        $missingCommands += $commandName
        Write-Host "[FALTA] $commandName" -ForegroundColor Red
    }
    else {
        Write-Host "[OK]    $commandName" -ForegroundColor Green
    }
}

if ($missingCommands.Count -gt 0) {
    throw "Instale as ferramentas ausentes antes de continuar: $($missingCommands -join ', ')"
}

Write-Host "Ambiente local pronto." -ForegroundColor Green
