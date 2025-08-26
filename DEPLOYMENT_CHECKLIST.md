# 📋 Check-list de validation CI/CD - GestionEvenStat

## ✅ Configuration initiale

### Fichiers de configuration
- [ ] `.dockerignore` créé et configuré
- [ ] `Dockerfile` avec build multi-stage
- [ ] `nginx.conf` optimisé pour Angular
- [ ] `docker-compose.yml` pour développement
- [ ] `docker-compose.prod.yml` pour production
- [ ] `.env.example` avec toutes les variables
- [ ] Workflow GitHub Actions `.github/workflows/ci-cd.yml`
- [ ] Scripts de déploiement dans `scripts/`
- [ ] `Makefile` avec toutes les commandes
- [ ] `README.md` mis à jour

### Variables d'environnement
- [ ] Copier `.env.example` vers `.env`
- [ ] Configurer `DOCKER_USERNAME`
- [ ] Configurer `DOCKER_PASSWORD` (Personal Access Token)
- [ ] Configurer `DOMAIN` si applicable

## 🔧 Tests locaux

### Build Angular
```bash
make install    # Installation des dépendances
make build      # Build de production
make test       # Tests unitaires
make lint       # Vérification du code
```
- [ ] Build Angular réussi
- [ ] Tests passent tous
- [ ] Pas d'erreurs de linting

### Docker local
```bash
make docker-build    # Construction de l'image
make docker-run      # Lancement du conteneur
make health         # Vérification de santé
```
- [ ] Image Docker construite sans erreur
- [ ] Conteneur démarre correctement
- [ ] Application accessible sur `http://localhost:8080`
- [ ] Health check répond correctement

### Docker Compose
```bash
make compose-dev     # Lancement avec Docker Compose
make logs           # Vérification des logs
```
- [ ] Services démarrent correctement
- [ ] Pas d'erreurs dans les logs
- [ ] Application fonctionnelle

## 🐳 Docker Hub

### Configuration
- [ ] Compte Docker Hub créé/accessible
- [ ] Personal Access Token généré
- [ ] Token configuré dans les variables d'environnement

### Publication
```bash
make build-push VERSION=1.0.0
```
- [ ] Image publiée sur Docker Hub
- [ ] Tags corrects (version + latest)
- [ ] Image téléchargeable publiquement

## 🔄 GitHub Actions

### Secrets GitHub
Aller dans Settings → Secrets and variables → Actions :

**Docker Hub**
- [ ] `DOCKER_USERNAME` configuré
- [ ] `DOCKER_PASSWORD` configuré

**Serveurs de déploiement** (optionnel)
- [ ] `STAGING_HOST` configuré
- [ ] `STAGING_USER` configuré  
- [ ] `STAGING_SSH_KEY` configuré
- [ ] `PROD_HOST` configuré
- [ ] `PROD_USER` configuré
- [ ] `PROD_SSH_KEY` configuré

### Pipeline de validation
- [ ] Push sur une branche de test
- [ ] Vérifier que le job `test` passe
- [ ] Vérifier que le job `build-and-push` passe
- [ ] Vérifier que l'image est publiée sur Docker Hub
- [ ] Vérifier les logs GitHub Actions

## 🚀 Déploiement

### Test de production locale
```bash
make deploy-prod VERSION=1.0.0
```
- [ ] Déploiement local en mode production réussi
- [ ] Application accessible
- [ ] Pas d'erreurs dans les logs

### Déploiement automatique
- [ ] Push sur `master` déclenche le déploiement
- [ ] Pipeline complet réussi
- [ ] Application déployée automatiquement

## 🔍 Validation finale

### Fonctionnalités application
- [ ] Page d'accueil charge correctement
- [ ] Navigation fonctionne
- [ ] Statistiques s'affichent
- [ ] Liste des événements accessible
- [ ] Liste des participants accessible
- [ ] Responsive design correct

### Performance et sécurité
- [ ] Temps de chargement acceptable
- [ ] Headers de sécurité présents
- [ ] Gzip activé
- [ ] Cache des assets configuré
- [ ] Health check répond

### Monitoring
- [ ] Logs accessibles avec `make logs`
- [ ] Métriques Docker visibles avec `make stats`
- [ ] Conteneurs listés avec `make ps`

## 📚 Documentation

### Mise à jour
- [ ] README.md complet et à jour
- [ ] Variables d'environnement documentées
- [ ] Commandes de développement expliquées
- [ ] Instructions de déploiement claires

### Équipe
- [ ] Instructions partagées avec l'équipe
- [ ] Accès aux secrets configurés
- [ ] Processus de déploiement documenté

## 🎯 Points critiques à vérifier

### Sécurité
- [ ] Pas de secrets dans le code source
- [ ] Utilisateur non-root dans Docker
- [ ] Headers de sécurité configurés
- [ ] Scan de vulnérabilités activé

### Robustesse
- [ ] Rollback automatique en cas d'échec
- [ ] Health checks configurés
- [ ] Gestion des erreurs appropriée
- [ ] Logs structurés

### Scalabilité
- [ ] Image multi-architecture (amd64, arm64)
- [ ] Configuration via variables d'environnement
- [ ] Resources Docker limitées
- [ ] Cache optimisé

## 🚨 Troubleshooting

### Problèmes courants

**Build Angular échoue :**
- Vérifier Node.js version (18+)
- Nettoyer node_modules : `rm -rf node_modules && npm install`
- Vérifier package.json

**Docker build échoue :**
- Vérifier .dockerignore
- Nettoyer cache Docker : `make docker-clean`
- Vérifier Dockerfile syntax

**Push Docker Hub échoue :**
- Vérifier credentials Docker Hub
- Vérifier format du nom d'image
- Tester manuellement : `docker login`

**GitHub Actions échoue :**
- Vérifier tous les secrets configurés
- Vérifier permissions du token
- Consulter les logs détaillés

**Déploiement échoue :**
- Vérifier connectivité SSH
- Vérifier permissions sur le serveur
- Vérifier espace disque disponible

## ✅ Validation complète

Une fois tous les points validés :

- [ ] Application Angular fonctionnelle
- [ ] Pipeline CI/CD opérationnel  
- [ ] Déploiement automatique actif
- [ ] Documentation complète
- [ ] Équipe formée

**🎉 Félicitations ! Votre pipeline CI/CD est opérationnel !**

---

💡 **Conseil :** Gardez cette check-list à jour au fur et à mesure des évolutions du projet.
