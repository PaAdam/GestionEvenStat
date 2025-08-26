# GestionEvenStat 🎯

> Application Angular de gestion d'événements et de statistiques avec pipeline CI/CD complet

[![Build Status](https://github.com/PaAdam/GestionEvenStat/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/PaAdam/GestionEvenStat/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/your-dockerhub-username/gestion-even-stat)](https://hub.docker.com/r/your-dockerhub-username/gestion-even-stat)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 📋 Table des matières

- [Vue d'ensemble](#-vue-densemble)
- [Technologies](#-technologies)
- [Démarrage rapide](#-démarrage-rapide)
- [Développement](#-développement)
- [Docker](#-docker)
- [Déploiement](#-déploiement)
- [CI/CD](#-cicd)
- [Scripts utiles](#-scripts-utiles)
- [Architecture](#-architecture)
- [Contribution](#-contribution)

## 🔍 Vue d'ensemble

GestionEvenStat est une application Angular moderne pour la gestion d'événements et l'affichage de statistiques. L'application inclut :

- 📊 Tableau de bord avec statistiques
- 📅 Gestion des événements
- 👥 Gestion des participants
- 📈 Visualisation des données avec des graphiques
- 🐳 Containerisation Docker
- 🚀 Pipeline CI/CD automatisé

## 🛠 Technologies

- **Frontend:** Angular 15, TypeScript, SCSS
- **UI/UX:** Angular Material, Bootstrap 5, Chart.js
- **Containerisation:** Docker, Docker Compose
- **CI/CD:** GitHub Actions
- **Serveur web:** Nginx
- **Outils:** ESLint, Karma, Jasmine

## 🚀 Démarrage rapide

### Prérequis
- Node.js 18+
- npm
- Docker & Docker Compose
- Git

### Installation locale

```bash
# Cloner le projet
git clone https://github.com/PaAdam/GestionEvenStat.git
cd GestionEvenStat

# Installer les dépendances
npm install

# Lancer en développement
npm start

# L'application sera disponible sur http://localhost:4200
```

### Avec Docker (recommandé)

```bash
# Démarrage rapide avec Docker
make compose-dev
# ou
docker-compose up -d

# L'application sera disponible sur http://localhost:8080
```

## 💻 Développement

### Commandes de développement

```bash
# Installation des dépendances
make install

# Lancement en mode développement
make dev

# Build de production
make build

# Tests
make test

# Linting
make lint

# Pipeline CI complet
make ci
```

### Structure du projet

```
src/
├── app/
│   ├── components/           # Composants Angular
│   │   ├── event-list/      # Liste des événements
│   │   ├── participant-list/ # Liste des participants
│   │   └── statistiques/    # Dashboard statistiques
│   ├── models/              # Modèles de données
│   └── services/            # Services Angular
├── assets/                  # Ressources statiques
└── styles.scss             # Styles globaux
```

## 🐳 Docker

### Images Docker

L'application utilise un build multi-stage pour optimiser la taille de l'image :

1. **Stage 1:** Build Angular avec Node.js
2. **Stage 2:** Serveur Nginx optimisé

### Commandes Docker

```bash
# Construire l'image
make docker-build

# Lancer l'application
make docker-run

# Pousser vers Docker Hub
make docker-push

# Voir les logs
make logs

# Nettoyer
make docker-clean
```

### Configuration Docker

- **Port:** 80 (production), 8080 (développement)
- **Health check:** Intégré
- **Sécurité:** Utilisateur non-root
- **Optimisations:** Gzip, cache statique, headers de sécurité

## 🚀 Déploiement

### Développement local

```bash
# Déploiement automatique local
make deploy-local
```

### Production

```bash
# Copier et configurer les variables d'environnement
cp .env.example .env
# Éditer .env avec vos valeurs

# Déployer en production
make deploy-prod VERSION=1.0.0
```

### Variables d'environnement

```bash
# Docker Hub
DOCKER_USERNAME=your-username
DOCKER_PASSWORD=your-token

# Application
DOMAIN=your-domain.com
NODE_ENV=production
```

## 🔄 CI/CD

Le pipeline GitHub Actions inclut :

### 🧪 Tests et qualité
- Tests unitaires avec Karma
- Linting avec ESLint
- Build de production
- Scan de sécurité avec Trivy

### 🐳 Build et publication
- Build multi-architecture (amd64, arm64)
- Push automatique sur Docker Hub
- Tagging intelligent (semver, branches)

### 🚀 Déploiement automatique
- **Staging:** Sur push vers `develop`
- **Production:** Sur push vers `master` ou release
- **Rollback:** Automatique en cas d'échec

### Configuration des secrets GitHub

```bash
# Docker Hub
DOCKER_USERNAME
DOCKER_PASSWORD

# Serveurs de déploiement
STAGING_HOST
STAGING_USER
STAGING_SSH_KEY

PROD_HOST
PROD_USER
PROD_SSH_KEY
```

## 📚 Scripts utiles

### Scripts de développement

```bash
# Afficher l'aide
make help

# Configuration complète
make setup

# Monitoring
make stats
make ps

# Nettoyage complet
make clean
```

### Scripts de déploiement

```bash
# Déploiement local avec vérifications
./scripts/deploy-local.sh

# Build et push Docker
./scripts/build-and-push.sh v1.0.0

# Déploiement production
./scripts/deploy-prod.sh v1.0.0
```

## 🏗 Architecture

### Frontend (Angular)
- Architecture modulaire avec lazy loading
- Services pour la gestion des données
- Composants réutilisables
- Responsive design

### Infrastructure
- **Nginx:** Serveur web optimisé
- **Docker:** Containerisation
- **Docker Compose:** Orchestration
- **GitHub Actions:** CI/CD

### Monitoring et observabilité
- Health checks intégrés
- Logs structurés
- Métriques Docker
- Scan de sécurité automatique

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Commit les changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

### Guidelines de contribution

- Suivre les conventions Angular
- Ajouter des tests pour les nouvelles fonctionnalités
- Mettre à jour la documentation
- Vérifier que le pipeline CI passe

## 📝 License

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 📞 Support

- 🐛 **Issues:** [GitHub Issues](https://github.com/PaAdam/GestionEvenStat/issues)
- 📧 **Email:** your-email@domain.com
- 💬 **Discussions:** [GitHub Discussions](https://github.com/PaAdam/GestionEvenStat/discussions)

---

⭐ N'oubliez pas de donner une étoile si ce projet vous a été utile !
