# Script de release automatique PowerShell
# Usage: .\release.ps1 [patch|minor|major]

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("patch", "minor", "major")]
    [string]$ReleaseType = "patch"
)

Write-Host "🚀 Starting release process..." -ForegroundColor Green

# Vérifier que nous sommes sur main
$currentBranch = git branch --show-current
if ($currentBranch -ne "main") {
    Write-Host "❌ You must be on main branch to create a release" -ForegroundColor Red
    exit 1
}

# Vérifier qu'il n'y a pas de changements non committes
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "❌ You have uncommitted changes. Please commit or stash them first." -ForegroundColor Red
    exit 1
}

# Récupérer les dernières modifications
git pull origin main

# Lire la version actuelle du package.json
$packageJson = Get-Content "package.json" | ConvertFrom-Json
$currentVersion = $packageJson.version
Write-Host "📋 Current version: $currentVersion" -ForegroundColor Yellow

# Calculer la nouvelle version
$versionParts = $currentVersion.Split('.')
$major = [int]$versionParts[0]
$minor = [int]$versionParts[1]
$patch = [int]$versionParts[2]

switch ($ReleaseType) {
    "patch" { $newVersion = "$major.$minor.$($patch + 1)" }
    "minor" { $newVersion = "$major.$($minor + 1).0" }
    "major" { $newVersion = "$($major + 1).0.0" }
}

Write-Host "🆙 New version: $newVersion" -ForegroundColor Green

# Mettre à jour la version dans package.json
$packageJson.version = $newVersion
$packageJson | ConvertTo-Json -Depth 10 | Set-Content "package.json"

# Mettre à jour la version dans le service de version
$servicePath = "src/app/services/version.service.ts"
$serviceContent = Get-Content $servicePath -Raw
$serviceContent = $serviceContent -replace "private readonly version = '[^']+'", "private readonly version = '$newVersion'"
Set-Content $servicePath $serviceContent

Write-Host "📝 Updated version files" -ForegroundColor Green

# Tester que l'application compile toujours
Write-Host "🔨 Testing build..." -ForegroundColor Yellow
npm run build:prod

Write-Host "🐳 Testing Docker build..." -ForegroundColor Yellow
docker build -t test-release .
docker rmi test-release

# Committer les changements
git add package.json src/app/services/version.service.ts
git commit -m "chore: bump version to $newVersion"

# Créer le tag
$tagMessage = @"
Release version $newVersion

🆕 What's new in v$newVersion:
- Version bump to $newVersion
- Automated release via GitHub Actions

🔗 Docker image: paadam/gestion-even-stat:v$newVersion
"@

git tag -a "v$newVersion" -m $tagMessage

Write-Host "✅ Version $newVersion ready!" -ForegroundColor Green
Write-Host ""
Write-Host "📤 To publish this release, run:" -ForegroundColor Cyan
Write-Host "   git push origin main --tags" -ForegroundColor White
Write-Host ""
Write-Host "🤖 This will trigger the GitHub Actions pipeline for automatic:" -ForegroundColor Cyan
Write-Host "   - Build and test" -ForegroundColor White
Write-Host "   - Docker image creation" -ForegroundColor White
Write-Host "   - Publication to Docker Hub" -ForegroundColor White
Write-Host "   - Deployment (if configured)" -ForegroundColor White
