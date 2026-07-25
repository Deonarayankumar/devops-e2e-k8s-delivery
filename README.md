# DevOps E2E K8s Delivery

Kubernetes delivery lab: containerized Python order API, Helm chart with environment overlays, Azure DevOps pipeline for ACR build/push and staged Helm deploys with production approval.

## Components

| Path | Description |
|------|-------------|
| `app/` | FastAPI order service + Dockerfile |
| `helm/order-service/` | Helm chart with dev/staging/prod values |
| `scripts/` | Rollback and smoke test helpers |
| `docs/rollback-runbook.md` | Operational rollback procedure |

## Prerequisites

- Docker, kubectl, Helm 3
- Azure AKS cluster and ACR
- Azure DevOps with Kubernetes service connections

## Local run

```bash
docker build -t order-service:local app/
docker run -p 8080:8080 order-service:local
curl http://localhost:8080/health
```

## Helm deploy (staging example)

```bash
helm upgrade --install order-service ./helm/order-service \
  -f helm/order-service/values-staging.yaml \
  --namespace staging --create-namespace
```

## Pipeline

Azure DevOps builds the image, pushes to ACR, deploys to staging, runs smoke tests, then deploys to production after approval.

## Learnings

- Values files per environment without duplicating templates
- `helm rollback` runbook for failed releases
- Smoke tests as a deployment gate
