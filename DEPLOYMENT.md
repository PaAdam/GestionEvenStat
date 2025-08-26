# GestionEvenStat - Guide de Déploiement CI/CD

## 📋 Vue d'ensemble

Cette application Angular utilise une chaîne CI/CD complète avec Docker, Docker Compose et GitHub Actions pour automatiser le build, les tests et le déploiement.

## 🛠️ Prérequis

- **Node.js** 18+ et npm
- **Docker** et Docker Compose
- **Git**
- Compte **Docker Hub** (pour la publication d'images)
- Serveurs de **staging** et **production** (pour le déploiement automatique)

## 🚀 Commandes Disponibles

### Développement Local

```bash
# Démarrer l'environnement de développement complet
npm run dev
# ou
docker-compose up

# Démarrer seulement Angular
npm start

# Démarrer seulement JSON Server
npm run start:json

# Tests
npm test
npm run test:ci

# Build de production
npm run build:prod
```

### Docker

```bash
# Build l'image Docker
npm run docker:build

# Lancer le conteneur en local
npm run docker:run

# Environnement de développement avec Docker
npm run docker:dev

# Environnement de production avec Docker
npm run docker:prod

# Arrêter tous les conteneurs
npm run docker:stop

# Nettoyer Docker
npm run docker:clean
```

### Publication Docker

```bash
# Se connecter à Docker Hub
docker login

# Publier une nouvelle version (build + tag + push)
npm run docker:publish

# Ou manuellement :
# 1. Builder l'image
npm run docker:build:prod

# 2. Créer un tag de version
docker tag paadam/gestion-even-stat:latest paadam/gestion-even-stat:v1.0.0

# 3. Publier sur Docker Hub
docker push paadam/gestion-even-stat:latest
docker push paadam/gestion-even-stat:v1.0.0
```

### Scripts de Déploiement

#### Linux/Mac
```bash
# Développement local
./scripts/deploy.sh local

# Build de production local
./scripts/deploy.sh local-prod

# Déploiement staging
./scripts/deploy.sh staging

# Déploiement production
./scripts/deploy.sh production
```

#### Windows PowerShell
```powershell
# Développement local
.\scripts\deploy.ps1 local

# Build de production local
.\scripts\deploy.ps1 local-prod

# Déploiement staging
.\scripts\deploy.ps1 staging

# Déploiement production
.\scripts\deploy.ps1 production
```

## 🔧 Configuration GitHub Actions

### Secrets Requis

Configurez ces secrets dans votre repository GitHub (`Settings > Secrets and variables > Actions`) :

```
# Docker Hub
DOCKER_USERNAME=votre_username_dockerhub
DOCKER_PASSWORD=votre_token_dockerhub

# Serveur de Staging
STAGING_HOST=ip_ou_domaine_staging
STAGING_USERNAME=username_ssh
STAGING_SSH_KEY=cle_privee_ssh
STAGING_PORT=22  # optionnel

# Serveur de Production
PRODUCTION_HOST=ip_ou_domaine_production
PRODUCTION_USERNAME=username_ssh
PRODUCTION_SSH_KEY=cle_privee_ssh
PRODUCTION_PORT=22  # optionnel
```

### Workflow Automatique

Le pipeline se déclenche automatiquement :

- **Push sur `main`** : Build, test, et déploiement staging
- **Push sur `develop`** : Build, test
- **Tags `v*`** : Build, test, et déploiement production
- **Pull Requests** : Build et test uniquement

## 🌐 Accès aux Environnements

| Environnement | URL | Port |
|---------------|-----|------|
| Développement | http://localhost:4200 | 4200 |
| JSON Server | http://localhost:3000 | 3000 |
| Production locale | http://localhost:8080 | 8080 |
| Staging | https://staging.votredomaine.com | 80/443 |
| Production | https://www.votredomaine.com | 80/443 |

## 📊 Monitoring et Health Checks

### Endpoints de Santé

- `/health` : Status de l'application
- `/proxy-health` : Status du proxy (si utilisé)

### Monitoring Docker

```bash
# Voir les logs
docker-compose logs -f

# Status des conteneurs
docker-compose ps

# Statistiques d'utilisation
docker stats
```

## 🔒 Sécurité

### Fonctionnalités Implémentées

- ✅ Utilisateur non-root dans le conteneur
- ✅ Headers de sécurité HTTP
- ✅ Audit de sécurité npm
- ✅ Scan des vulnérabilités
- ✅ Images multi-architecture
- ✅ Nettoyage automatique des ressources

### SSL/HTTPS (Production)

Pour activer HTTPS en production :

1. Obtenir des certificats SSL
2. Décommenter les lignes SSL dans `nginx-proxy.conf`
3. Monter les certificats dans docker-compose.prod.yml

## 🚨 Dépannage

### Problèmes Courants

#### Build échoue avec erreur de mémoire
```bash
# Augmenter la limite de mémoire Node.js
export NODE_OPTIONS="--max-old-space-size=4096"
npm run build:prod
```

#### Problèmes de permissions Docker
```bash
# Linux/Mac
sudo chown -R $USER:$USER .
```

#### Port déjà utilisé
```bash
# Voir les processus utilisant le port
netstat -tulpn | grep :8080

# Arrêter tous les conteneurs Docker
docker kill $(docker ps -q)
```

### Logs Utiles

```bash
# Logs Docker Compose
docker-compose logs -f [service_name]

# Logs GitHub Actions
# Consultez l'onglet "Actions" de votre repository

# Logs du serveur
journalctl -u docker
```

## 📈 Performance

### Optimisations Implémentées

- ✅ Build multi-stage Docker
- ✅ Compression gzip
- ✅ Cache des assets statiques
- ✅ Cache Docker pour CI/CD
- ✅ Images optimisées (Alpine Linux)
- ✅ Lazy loading Angular

### Métriques de Performance

- **Taille de l'image Docker** : ~50MB
- **Temps de build** : ~3-5 minutes
- **Temps de déploiement** : ~1-2 minutes

## 🔄 Processus de Release

1. **Développement** : Travail sur branche feature
2. **Pull Request** : Code review + tests automatiques
3. **Merge sur develop** : Déploiement automatique staging
4. **Tag version** : `git tag v1.0.0 && git push --tags`
5. **Déploiement production** : Automatique via GitHub Actions

## 📞 Support

En cas de problème :

1. Vérifiez les logs des conteneurs
2. Consultez les Actions GitHub
3. Vérifiez la connectivité réseau
4. Testez localement avec `docker-compose`

---

Made with ❤️ for GestionEvenStat
