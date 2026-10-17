# TP09 — Aplicación de notas en Kubernetes

## Descripción
Este trabajo práctico consiste en desplegar una aplicación de notas en Kubernetes, utilizando PostgreSQL como base de datos, un backend y un frontend web.

## Arquitectura
- **Namespace:** `devops-portfolio`.
- **Base de datos:** PostgreSQL 16 con Deployment, Service ClusterIP y PVC de 1 GiB.
- **Backend:** 2 réplicas, estrategia RollingUpdate y health probes.
- **Frontend:** 2 réplicas con Service NodePort en el puerto 30080.
- **ConfigMap:** configuración de la aplicación.
- **Secret:** credenciales de la base de datos.
- **Scripts:** automatización del despliegue y verificación de recursos.

## Estructura del proyecto
- `frontend/`: Dockerfile e interfaz web.
- `manifests/base/`: namespace.
- `manifests/db/`: recursos de PostgreSQL y persistencia.
- `manifests/backend/`: recursos del backend.
- `manifests/frontend/`: recursos del frontend.
- `scripts/deploy.sh`: despliegue automatizado.
- `scripts/verificar.sh`: verificación del despliegue.

## Despliegue
Desde la raíz del proyecto, ejecutar:

    bash scripts/deploy.sh

## Verificación
Para consultar los recursos desplegados:

    kubectl get pods -n devops-portfolio
    kubectl get deployments -n devops-portfolio
    kubectl get services -n devops-portfolio

El frontend utiliza el puerto NodePort 30080. La dirección de acceso depende del entorno Kubernetes.

## Seguridad
Las credenciales se administran mediante un recurso Secret. El archivo con credenciales no debe subirse al repositorio público.

## Objetivo
Practicar la administración de recursos Kubernetes, la persistencia de datos, la configuración de aplicaciones, las comprobaciones de salud y la automatización de despliegues.
