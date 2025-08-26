# Deploy script for GestionEvenStat (PowerShell version)
# Usage: .\deploy.ps1 [environment]
# Environments: local, staging, production

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("local", "local-prod", "staging", "production")]
    [string]$Environment = "local"
)

$PROJECT_NAME = "gestion-even-stat"
$DOCKER_IMAGE = "paadam/gestion-even-stat"

Write-Host "🚀 Starting deployment for environment: $Environment" -ForegroundColor Green

switch ($Environment) {
    "local" {
        Write-Host "📦 Building for local development..." -ForegroundColor Yellow
        docker-compose down --remove-orphans
        docker-compose up --build -d
        Write-Host "✅ Local development environment is running on http://localhost:4200" -ForegroundColor Green
        Write-Host "📊 JSON Server is running on http://localhost:3000" -ForegroundColor Green
    }
    
    "local-prod" {
        Write-Host "🏗️ Building production image locally..." -ForegroundColor Yellow
        docker build -t "${DOCKER_IMAGE}:local" .
        docker run -d --name "$PROJECT_NAME-local" -p 8080:80 "${DOCKER_IMAGE}:local"
        Write-Host "✅ Local production build is running on http://localhost:8080" -ForegroundColor Green
    }
    
    "staging" {
        Write-Host "🔄 Deploying to staging environment..." -ForegroundColor Yellow
        docker-compose -f docker-compose.prod.yml pull
        docker-compose -f docker-compose.prod.yml up -d --remove-orphans
        Write-Host "✅ Staging deployment completed" -ForegroundColor Green
    }
    
    "production" {
        Write-Host "🚨 Deploying to PRODUCTION environment..." -ForegroundColor Red
        $confirm = Read-Host "Are you sure you want to deploy to production? (yes/no)"
        if ($confirm -ne "yes") {
            Write-Host "❌ Deployment cancelled" -ForegroundColor Red
            exit 1
        }
        
        # Pull latest images
        docker-compose -f docker-compose.prod.yml pull
        
        # Deploy with zero downtime
        docker-compose -f docker-compose.prod.yml up -d --remove-orphans
        
        # Clean up old images
        docker image prune -f
        
        Write-Host "✅ Production deployment completed" -ForegroundColor Green
    }
}

Write-Host "🎉 Deployment completed successfully!" -ForegroundColor Green

# Health check
if ($Environment -ne "local") {
    Write-Host "🩺 Running health check..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    try {
        $response = Invoke-WebRequest -Uri "http://localhost/health" -Method GET -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Health check passed" -ForegroundColor Green
        } else {
            Write-Host "❌ Health check failed" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "❌ Health check failed: $_" -ForegroundColor Red
        exit 1
    }
}
