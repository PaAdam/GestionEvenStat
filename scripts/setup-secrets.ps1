# Configuration des secrets GitHub Actions
# Usage: .\setup-secrets.ps1

Write-Host "🔐 Configuration des secrets GitHub Actions" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# Vérifier si GitHub CLI est authentifié
try {
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Non authentifié avec GitHub CLI" -ForegroundColor Red
        Write-Host "Exécutez: gh auth login" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✅ Authentifié avec GitHub CLI" -ForegroundColor Green
} catch {
    Write-Host "❌ Erreur GitHub CLI" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📋 Secrets requis pour Docker Hub :" -ForegroundColor Yellow
Write-Host "- DOCKER_USERNAME : Nom d'utilisateur Docker Hub"
Write-Host "- DOCKER_PASSWORD : Token Docker Hub"

Write-Host ""
$setupDocker = Read-Host "Configurer les secrets Docker Hub ? (O/n)"

if ($setupDocker -ne "n" -and $setupDocker -ne "N") {
    Write-Host ""
    $dockerUsername = Read-Host "Nom d'utilisateur Docker Hub"
    $dockerPassword = Read-Host "Token Docker Hub (créé sur https://hub.docker.com/settings/security)" -AsSecureString
    
    # Convertir SecureString en texte
    $dockerPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dockerPassword))
    
    Write-Host ""
    Write-Host "🔧 Configuration des secrets..." -ForegroundColor Yellow
    
    try {
        gh secret set DOCKER_USERNAME --body $dockerUsername
        Write-Host "✅ DOCKER_USERNAME configuré" -ForegroundColor Green
        
        gh secret set DOCKER_PASSWORD --body $dockerPasswordText
        Write-Host "✅ DOCKER_PASSWORD configuré" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "🎉 Secrets Docker Hub configurés avec succès !" -ForegroundColor Green
        
    } catch {
        Write-Host "❌ Erreur lors de la configuration des secrets" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📊 Liste des secrets configurés :" -ForegroundColor Yellow
gh secret list

Write-Host ""
Write-Host "🚀 Votre pipeline CI/CD est maintenant prêt !" -ForegroundColor Green
Write-Host "Les prochains commits/tags déclencheront automatiquement le build et le déploiement." -ForegroundColor Green
