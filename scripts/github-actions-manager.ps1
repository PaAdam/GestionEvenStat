# Script PowerShell pour vérifier et configurer GitHub Actions
# Author: Generated for GestionEvenStat project

param(
    [string]$Action = "status"
)

$Repository = "PaAdam/GestionEvenStat"
$GitHubUrl = "https://github.com/$Repository"

function Show-ActionsStatus {
    Write-Host "🔍 Statut GitHub Actions pour $Repository" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "📊 Dashboard Actions :" -ForegroundColor Yellow
    Write-Host "  → $GitHubUrl/actions" -ForegroundColor White
    
    Write-Host ""
    Write-Host "⚙️ Workflows configurés :" -ForegroundColor Yellow
    Write-Host "  ✅ CI/CD Pipeline (.github/workflows/ci-cd.yml)" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "🔐 Secrets requis :" -ForegroundColor Yellow
    Write-Host "  🔸 DOCKER_USERNAME" -ForegroundColor White
    Write-Host "  🔸 DOCKER_PASSWORD" -ForegroundColor White
    
    Write-Host ""
    $choice = Read-Host "Voulez-vous ouvrir le dashboard GitHub Actions ? (O/n)"
    
    if ($choice -ne "n" -and $choice -ne "N") {
        Start-Process "$GitHubUrl/actions"
    }
}

function Show-SecretConfiguration {
    Write-Host "🔐 Configuration des secrets GitHub" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Cyan
    
    $secretsUrl = "$GitHubUrl/settings/secrets/actions"
    
    Write-Host ""
    Write-Host "📋 Étapes de configuration :" -ForegroundColor Yellow
    Write-Host "1. Créer un token Docker Hub" -ForegroundColor White
    Write-Host "2. Configurer les secrets sur GitHub" -ForegroundColor White
    Write-Host "3. Vérifier le pipeline" -ForegroundColor White
    
    Write-Host ""
    Write-Host "🐳 Token Docker Hub :" -ForegroundColor Green
    Write-Host "  → https://hub.docker.com/settings/security" -ForegroundColor White
    Write-Host "  → Nom: 'GestionEvenStat-CI'" -ForegroundColor Gray
    Write-Host "  → Permissions: Read, Write, Delete" -ForegroundColor Gray
    
    Write-Host ""
    Write-Host "⚙️ Secrets GitHub :" -ForegroundColor Green
    Write-Host "  → $secretsUrl" -ForegroundColor White
    
    Write-Host ""
    $choice = Read-Host "Voulez-vous ouvrir les pages de configuration ? (O/n)"
    
    if ($choice -ne "n" -and $choice -ne "N") {
        Start-Process "https://hub.docker.com/settings/security"
        Start-Sleep 2
        Start-Process $secretsUrl
    }
}

function Test-GitHubCLI {
    Write-Host "🔧 Test GitHub CLI" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Cyan
    
    $ghInstalled = Get-Command gh -ErrorAction SilentlyContinue
    
    if ($ghInstalled) {
        Write-Host "✅ GitHub CLI est installé" -ForegroundColor Green
        
        try {
            $authStatus = & gh auth status 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Authentifié avec GitHub" -ForegroundColor Green
                
                Write-Host ""
                Write-Host "🔧 Commandes disponibles :" -ForegroundColor Yellow
                Write-Host "  gh secret set DOCKER_USERNAME --body 'votre_username'" -ForegroundColor White
                Write-Host "  gh secret set DOCKER_PASSWORD --body 'votre_token'" -ForegroundColor White
                Write-Host "  gh secret list" -ForegroundColor White
                
                $useGH = Read-Host "Voulez-vous utiliser GitHub CLI pour configurer les secrets ? (O/n)"
                
                if ($useGH -ne "n" -and $useGH -ne "N") {
                    $username = Read-Host "Nom d'utilisateur Docker Hub"
                    $password = Read-Host "Token Docker Hub" -AsSecureString
                    $passwordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
                    
                    & gh secret set DOCKER_USERNAME --body $username
                    & gh secret set DOCKER_PASSWORD --body $passwordText
                    
                    Write-Host "✅ Secrets configurés avec succès !" -ForegroundColor Green
                }
    } else {
        Write-Host "Non authentifie avec GitHub" -ForegroundColor Red
        Write-Host "Executez: gh auth login" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Erreur d'authentification GitHub CLI" -ForegroundColor Red
}
    } else {
        Write-Host "GitHub CLI n'est pas installe" -ForegroundColor Red
        Write-Host "Installation: winget install --id GitHub.cli" -ForegroundColor Yellow
    }
}

# Menu principal
switch ($Action.ToLower()) {
    "status" { Show-ActionsStatus }
    "secrets" { Show-SecretConfiguration }
    "cli" { Test-GitHubCLI }
    default {
        Write-Host "🚀 GitHub Actions Manager" -ForegroundColor Cyan
        Write-Host "=" * 30 -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Actions disponibles :" -ForegroundColor Yellow
        Write-Host "  status  - Afficher le statut des Actions" -ForegroundColor White
        Write-Host "  secrets - Configurer les secrets" -ForegroundColor White
        Write-Host "  cli     - Utiliser GitHub CLI" -ForegroundColor White
        Write-Host ""
        
        $choice = Read-Host "Quelle action souhaitez-vous effectuer ? [status/secrets/cli]"
        
        switch ($choice.ToLower()) {
            "status" { Show-ActionsStatus }
            "secrets" { Show-SecretConfiguration }
            "cli" { Test-GitHubCLI }
            default { Show-ActionsStatus }
        }
    }
}
