# Vérification du statut GitHub Actions
# Usage: .\check-actions.ps1

Write-Host "📊 Statut GitHub Actions - GestionEvenStat" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

# Vérifier l'authentification
try {
    gh auth status | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Non authentifié. Exécutez: gh auth login" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ GitHub CLI non disponible" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔐 Secrets configurés :" -ForegroundColor Yellow
gh secret list

Write-Host ""
Write-Host "⚙️ Workflows récents :" -ForegroundColor Yellow
gh run list --limit 5

Write-Host ""
Write-Host "🌐 Liens utiles :" -ForegroundColor Yellow
Write-Host "- Dashboard Actions : https://github.com/PaAdam/GestionEvenStat/actions"
Write-Host "- Configuration secrets : https://github.com/PaAdam/GestionEvenStat/settings/secrets/actions"
Write-Host "- Docker Hub : https://hub.docker.com/r/paadam/gestion-even-stat"

Write-Host ""
$openDashboard = Read-Host "Ouvrir le dashboard GitHub Actions ? (O/n)"

if ($openDashboard -ne "n" -and $openDashboard -ne "N") {
    Start-Process "https://github.com/PaAdam/GestionEvenStat/actions"
}
