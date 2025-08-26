#!/usr/bin/env powershell

# Script pour configurer les secrets GitHub Actions
# Author: Generated for GestionEvenStat project

param(
    [string]$Repository = "PaAdam/GestionEvenStat"
)

Write-Host "🔐 Configuration des secrets GitHub Actions" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Récupérer l'URL du repository
$repoUrl = "https://github.com/$Repository"
$secretsUrl = "$repoUrl/settings/secrets/actions"

Write-Host ""
Write-Host "📋 Secrets requis pour le pipeline CI/CD :" -ForegroundColor Yellow
Write-Host "-------------------------------------------"
Write-Host "✅ DOCKER_USERNAME    : Nom d'utilisateur Docker Hub"
Write-Host "✅ DOCKER_PASSWORD    : Token/Mot de passe Docker Hub"
Write-Host ""
Write-Host "🌐 Secrets optionnels pour le déploiement :" -ForegroundColor Yellow
Write-Host "---------------------------------------------"
Write-Host "🔸 STAGING_HOST       : IP/hostname serveur de staging"
Write-Host "🔸 STAGING_USERNAME   : Nom d'utilisateur SSH"
Write-Host "🔸 STAGING_SSH_KEY    : Clé privée SSH"
Write-Host "🔸 STAGING_PORT       : Port SSH (défaut: 22)"
Write-Host ""
Write-Host "🔸 PRODUCTION_HOST    : IP/hostname serveur de production"
Write-Host "🔸 PRODUCTION_USERNAME: Nom d'utilisateur SSH"
Write-Host "🔸 PRODUCTION_SSH_KEY : Clé privée SSH"
Write-Host "🔸 PRODUCTION_PORT    : Port SSH (défaut: 22)"

Write-Host ""
Write-Host "🚀 Instructions :" -ForegroundColor Green
Write-Host "----------------"
Write-Host "1. Créez un token Docker Hub :"
Write-Host "   → Allez sur https://hub.docker.com/settings/security"
Write-Host "   → Cliquez sur 'New Access Token'"
Write-Host "   → Nom: 'GestionEvenStat-CI'"
Write-Host "   → Permissions: Read, Write, Delete"
Write-Host ""
Write-Host "2. Configurez les secrets sur GitHub :"
Write-Host "   → URL : $secretsUrl"
Write-Host "   → Cliquez sur 'New repository secret'"
Write-Host "   → Ajoutez DOCKER_USERNAME et DOCKER_PASSWORD"

Write-Host ""
$choice = Read-Host "Voulez-vous ouvrir la page des secrets GitHub maintenant ? (O/n)"

if ($choice -ne "n" -and $choice -ne "N") {
    Write-Host "🌐 Ouverture de la page des secrets..." -ForegroundColor Green
    Start-Process $secretsUrl
    
    Write-Host ""
    Write-Host "📝 Créer un token Docker Hub..." -ForegroundColor Green
    Start-Process "https://hub.docker.com/settings/security"
}

Write-Host ""
Write-Host "Configuration terminee !" -ForegroundColor Green
Write-Host "Une fois les secrets configures, votre pipeline sera fonctionnel." -ForegroundColor Green
