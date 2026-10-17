#!/bin/bash
set -euo pipefail

ENV="${1:-}"

if [ "$ENV" != "staging" ] && [ "$ENV" != "production" ]; then
    echo "Uso: $0 [staging|production]"
    exit 1
fi

echo -e "\n\033[1;34m=== Desplegando en Namespace: $ENV ===\033[0m"

# Aplicar recursos en el namespace objetivo
kubectl apply -f k8s/base/01-secret.yml -n "$ENV"
kubectl apply -f k8s/base/02-pvc.yml -n "$ENV"
kubectl apply -f k8s/base/03-postgres-deployment.yml -n "$ENV"
kubectl apply -f k8s/base/04-postgres-service.yml -n "$ENV"
kubectl apply -f k8s/base/05-configmap.yml -n "$ENV"
kubectl apply -f k8s/base/06-backend-deployment.yml -n "$ENV"
kubectl apply -f k8s/base/07-backend-service.yml -n "$ENV"
kubectl apply -f k8s/base/08-frontend-deployment.yml -n "$ENV"
kubectl apply -f k8s/base/09-frontend-service.yml -n "$ENV"

echo "Esperando consolidación de despliegue en $ENV..."
kubectl rollout status deployment/notes-backend -n "$ENV" --timeout=60s

echo -e "\033[0;32m[OK] Despliegue completado con éxito en $ENV\033[0m"
