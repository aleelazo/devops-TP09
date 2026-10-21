#!/bin/bash
set -euo pipefail

ERRORES=0

ok()   { echo -e "  \033[0;32m[OK]\033[0m $1"; }
fail() { echo -e "  \033[0;31m[FAIL]\033[0m $1"; ERRORES=$((ERRORES + 1)); }
info() { echo -e "\n\033[1;34m=== $1 ===\033[0m"; }

info "1. Verificando Aislamiento de Namespaces"
for ns in staging production; do
    if kubectl get namespace "$ns" &>/dev/null; then
        ok "Namespace '$ns' presente y activo."
    else
        fail "Namespace '$ns' no encontrado."
    fi
done

info "2. Verificando Réplicas y Salud de Backend en Producción"
DESIRED=$(kubectl get deployment notes-backend -n production -o jsonpath='{.spec.replicas}')
READY=$(kubectl get deployment notes-backend -n production -o jsonpath='{.status.readyReplicas}')
READY=${READY:-0}

if [[ "$DESIRED" =~ ^[0-9]+$ ]] && [[ "$READY" =~ ^[0-9]+$ ]] && [ "$READY" -eq "$DESIRED" ] && [ "$READY" -ge 2 ]; then
    ok "Alta disponibilidad: $READY/$DESIRED réplicas listas en producción."
else
    fail "Inconsistencia en producción: $READY/$DESIRED réplicas listas."
fi

info "3. Verificando Estrategia RollingUpdate"
STRATEGY=$(kubectl get deployment notes-backend -n production -o jsonpath='{.spec.strategy.type}')
MAX_UNAVAIL=$(kubectl get deployment notes-backend -n production -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}')

if [ "$STRATEGY" = "RollingUpdate" ] && [ "$MAX_UNAVAIL" = "0" ]; then
    ok "Estrategia Zero-Downtime validada (RollingUpdate con maxUnavailable: 0)."
else
    fail "Configuración subóptima (Estrategia: $STRATEGY, maxUnavailable: $MAX_UNAVAIL)."
fi

if [ "$ERRORES" -eq 0 ]; then
    echo -e "\n\033[1;32mAuditoría de resiliencia finalizada: todas las comprobaciones pasaron.\033[0m\n"
else
    echo -e "\n\033[1;31mAuditoría finalizada con $ERRORES comprobación(es) fallida(s).\033[0m\n"
    exit 1
fi
