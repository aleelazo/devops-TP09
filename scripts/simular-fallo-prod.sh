#!/bin/bash
set -euo pipefail

echo -e "\033[1;31m=== LANZANDO RELEASE CORRUPTO (v2.0.0-broken) EN PRODUCCIÓN ===\033[0m"

# Actualizamos la imagen a una etiqueta inexistente o defectuosa
kubectl set image deployment/notes-backend backend=redis:alpine-nonexistent -n production

echo "Monitoreando el estado del rollout en tiempo real..."
echo "(Observa cómo Kubernetes intenta levantar el nuevo Pod sin apagar los viejos)"
