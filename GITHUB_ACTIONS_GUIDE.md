# 🚀 Guide de Configuration GitHub Actions

## Étapes de configuration

### 1. Authentification GitHub CLI
```powershell
gh auth login
```
- Choisir "GitHub.com"
- Choisir "HTTPS" 
- Accepter les permissions
- Authentification via navigateur

### 2. Créer un token Docker Hub
1. Aller sur https://hub.docker.com/settings/security
2. Cliquer sur "New Access Token"
3. Nom: `GestionEvenStat-CI`
4. Permissions: `Read, Write, Delete`
5. Copier le token généré

### 3. Configurer les secrets GitHub
```powershell
# Méthode automatique
npm run github:setup

# Méthode manuelle
gh secret set DOCKER_USERNAME --body "votre_username"
gh secret set DOCKER_PASSWORD --body "votre_token"
```

### 4. Vérifier la configuration
```powershell
# Vérifier les secrets
npm run github:check

# Voir les workflows
gh run list

# Voir les secrets
gh secret list
```

### 5. Tester le pipeline
```powershell
# Créer une release (déclenche le pipeline)
npm run release:patch

# Ou simplement pousser vers main
git push origin main
```

## 📊 Commandes utiles

| Commande | Description |
|----------|-------------|
| `npm run github:setup` | Configuration interactive des secrets |
| `npm run github:check` | Vérifier le statut des Actions |
| `gh run list` | Lister les exécutions récentes |
| `gh run view` | Voir les détails d'une exécution |
| `gh secret list` | Lister les secrets configurés |

## 🔗 Liens utiles

- **Dashboard Actions**: https://github.com/PaAdam/GestionEvenStat/actions
- **Configuration secrets**: https://github.com/PaAdam/GestionEvenStat/settings/secrets/actions  
- **Docker Hub**: https://hub.docker.com/r/paadam/gestion-even-stat
- **Token Docker Hub**: https://hub.docker.com/settings/security

## ✅ Checklist finale

- [ ] GitHub CLI installé et authentifié
- [ ] Token Docker Hub créé
- [ ] Secrets DOCKER_USERNAME et DOCKER_PASSWORD configurés
- [ ] Pipeline testé avec un commit/tag
- [ ] Image Docker publiée automatiquement
