#!/bin/bash

# Deploy script for GestionEvenStat
# Usage: ./deploy.sh [environment]
# Environments: local, staging, production

set -e

ENVIRONMENT=${1:-local}
PROJECT_NAME="gestion-even-stat"
DOCKER_IMAGE="paadam/gestion-even-stat"

echo "🚀 Starting deployment for environment: $ENVIRONMENT"

case $ENVIRONMENT in
  "local")
    echo "📦 Building for local development..."
    docker-compose down --remove-orphans
    docker-compose up --build -d
    echo "✅ Local development environment is running on http://localhost:4200"
    echo "📊 JSON Server is running on http://localhost:3000"
    ;;
    
  "local-prod")
    echo "🏗️ Building production image locally..."
    docker build -t $DOCKER_IMAGE:local .
    docker run -d --name $PROJECT_NAME-local -p 8080:80 $DOCKER_IMAGE:local
    echo "✅ Local production build is running on http://localhost:8080"
    ;;
    
  "staging")
    echo "🔄 Deploying to staging environment..."
    docker-compose -f docker-compose.prod.yml pull
    docker-compose -f docker-compose.prod.yml up -d --remove-orphans
    echo "✅ Staging deployment completed"
    ;;
    
  "production")
    echo "🚨 Deploying to PRODUCTION environment..."
    read -p "Are you sure you want to deploy to production? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
      echo "❌ Deployment cancelled"
      exit 1
    fi
    
    # Pull latest images
    docker-compose -f docker-compose.prod.yml pull
    
    # Deploy with zero downtime
    docker-compose -f docker-compose.prod.yml up -d --remove-orphans
    
    # Clean up old images
    docker image prune -f
    
    echo "✅ Production deployment completed"
    ;;
    
  *)
    echo "❌ Unknown environment: $ENVIRONMENT"
    echo "Available environments: local, local-prod, staging, production"
    exit 1
    ;;
esac

echo "🎉 Deployment completed successfully!"

# Health check
if [ "$ENVIRONMENT" != "local" ]; then
  echo "🩺 Running health check..."
  sleep 10
  if curl -f http://localhost/health > /dev/null 2>&1; then
    echo "✅ Health check passed"
  else
    echo "❌ Health check failed"
    exit 1
  fi
fi
