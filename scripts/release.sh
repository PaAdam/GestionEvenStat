#!/bin/bash

# Script de release automatique
# Usage: ./release.sh [patch|minor|major]

set -e

RELEASE_TYPE=${1:-patch}
echo "🚀 Starting release process..."

# Vérifier que nous sommes sur main
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ You must be on main branch to create a release"
    exit 1
fi

# Vérifier qu'il n'y a pas de changements non committes
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ You have uncommitted changes. Please commit or stash them first."
    exit 1
fi

# Récupérer les dernières modifications
git pull origin main

# Lire la version actuelle du package.json
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo "📋 Current version: $CURRENT_VERSION"

# Calculer la nouvelle version
case $RELEASE_TYPE in
    "patch")
        NEW_VERSION=$(node -p "
            const [major, minor, patch] = '$CURRENT_VERSION'.split('.').map(Number);
            [major, minor, patch + 1].join('.');
        ")
        ;;
    "minor")
        NEW_VERSION=$(node -p "
            const [major, minor] = '$CURRENT_VERSION'.split('.').map(Number);
            [major, minor + 1, 0].join('.');
        ")
        ;;
    "major")
        NEW_VERSION=$(node -p "
            const [major] = '$CURRENT_VERSION'.split('.').map(Number);
            [major + 1, 0, 0].join('.');
        ")
        ;;
    *)
        echo "❌ Invalid release type: $RELEASE_TYPE. Use patch, minor, or major."
        exit 1
        ;;
esac

echo "🆙 New version: $NEW_VERSION"

# Mettre à jour la version dans package.json
node -e "
    const fs = require('fs');
    const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
    pkg.version = '$NEW_VERSION';
    fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
"

# Mettre à jour la version dans le service de version
node -e "
    const fs = require('fs');
    const servicePath = 'src/app/services/version.service.ts';
    let content = fs.readFileSync(servicePath, 'utf8');
    content = content.replace(
        /private readonly version = '[^']+'/,
        \"private readonly version = '$NEW_VERSION'\"
    );
    fs.writeFileSync(servicePath, content);
"

echo "📝 Updated version files"

# Tester que l'application compile toujours
echo "🔨 Testing build..."
npm run build:prod

echo "🐳 Testing Docker build..."
docker build -t test-release .
docker rmi test-release

# Committer les changements
git add package.json src/app/services/version.service.ts
git commit -m "chore: bump version to $NEW_VERSION"

# Créer le tag
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION

🆕 What's new in v$NEW_VERSION:
- Version bump to $NEW_VERSION
- Automated release via GitHub Actions

🔗 Docker image: paadam/gestion-even-stat:v$NEW_VERSION
"

echo "✅ Version $NEW_VERSION ready!"
echo ""
echo "📤 To publish this release, run:"
echo "   git push origin main --tags"
echo ""
echo "🤖 This will trigger the GitHub Actions pipeline for automatic:"
echo "   - Build and test"
echo "   - Docker image creation"
echo "   - Publication to Docker Hub"
echo "   - Deployment (if configured)"
