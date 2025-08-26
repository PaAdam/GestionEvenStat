#!/bin/bash

# Script pour vérifier le statut du pipeline GitHub Actions
# Author: Generated for GestionEvenStat project

REPO="PaAdam/GestionEvenStat"
API_URL="https://api.github.com/repos/$REPO"

echo "🔍 Vérification du statut GitHub Actions"
echo "========================================"

# Vérifier les workflows
echo ""
echo "📋 Workflows disponibles :"
curl -s "$API_URL/actions/workflows" | grep -o '"name":"[^"]*"' | sed 's/"name":"//g' | sed 's/"//g' | while read workflow; do
    echo "  ✅ $workflow"
done

echo ""
echo "🚀 Dernières exécutions :"
curl -s "$API_URL/actions/runs?per_page=5" | grep -o '"head_commit":{"id":"[^"]*","message":"[^"]*"' | sed 's/"head_commit":{"id":"//g' | sed 's/","message":"/ - /g' | while read run; do
    echo "  🔸 $run"
done

echo ""
echo "🔐 Pour configurer les secrets :"
echo "  → https://github.com/$REPO/settings/secrets/actions"

echo ""
echo "📊 Dashboard Actions :"
echo "  → https://github.com/$REPO/actions"
