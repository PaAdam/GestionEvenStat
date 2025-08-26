# Configuration rapide des secrets GitHub Actions
# Version simplifiee pour PowerShell

Write-Host "Configuration des secrets GitHub Actions" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$Repository = "PaAdam/GestionEvenStat"
$SecretsUrl = "https://github.com/$Repository/settings/secrets/actions"
$DockerHubUrl = "https://hub.docker.com/settings/security"

Write-Host ""
Write-Host "Etapes a suivre :" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Creer un token Docker Hub :" -ForegroundColor Green
Write-Host "   - Nom du token: GestionEvenStat-CI"
Write-Host "   - Permissions: Read, Write, Delete"
Write-Host "   - URL: $DockerHubUrl"
Write-Host ""
Write-Host "2. Configurer les secrets GitHub :" -ForegroundColor Green
Write-Host "   - DOCKER_USERNAME (votre nom d'utilisateur Docker Hub)"
Write-Host "   - DOCKER_PASSWORD (le token cree a l'etape 1)"
Write-Host "   - URL: $SecretsUrl"
Write-Host ""
Write-Host "3. Verifier le pipeline :" -ForegroundColor Green
Write-Host "   - URL: https://github.com/$Repository/actions"

Write-Host ""
$openPages = Read-Host "Ouvrir les pages de configuration ? (O/n)"

if ($openPages -ne "n" -and $openPages -ne "N") {
    Write-Host "Ouverture des pages..." -ForegroundColor Green
    Start-Process $DockerHubUrl
    Start-Sleep 2
    Start-Process $SecretsUrl
    Start-Sleep 2
    Start-Process "https://github.com/$Repository/actions"
}

Write-Host ""
Write-Host "Configuration terminee !" -ForegroundColor Green
