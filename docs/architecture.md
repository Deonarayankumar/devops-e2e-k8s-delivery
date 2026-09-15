# Architecture

Project window: **July 2026 – August 2026**.

This repository is the flagship Kubernetes platform lab. Application sources live under `apps/`. Infrastructure (Terraform) lives under `infra/`. Cluster desired state is GitOps under `gitops/` and `charts/`.

```
                    GitHub
                      │
              ┌───────┴────────┐
              │                 │
        Application path    Infrastructure path
        (apps/, charts/)    (infra/)
              │                 │
        GitHub Actions       Terraform
              │                 │
        Build/Test/Scan      Azure
              │                 │
              ▼                 ▼
           Docker           VNet
              │             AKS
              │                 │
              └───────┬─────────┘
                      │
                   Argo CD
                      │
                      ▼
              ┌───────────────┐
              │ Kubernetes    │
              │ Frontend      │
              │ Backend       │
              │ Database      │
              └───────┬───────┘
                      │
             ┌────────┴─────────┐
             │                  │
        OpenTelemetry      Prometheus
             │                  │
             ▼                  ▼
           Tempo             Grafana
             │                  │
             └────────┬─────────┘
                      │
                   Alerts
                      │
                   PagerDuty /
                   Slack
```

## Delivery

```
Git push
  → GitHub Actions
  → unit tests
  → Docker build
  → Trivy scan
  → (main) pin Helm values
  → Argo CD sync
  → Kubernetes
```

Progressive delivery strategies are Helm values:

| Overlay | Strategy |
|---------|----------|
| `values-prod.yaml` | rolling |
| `values-staging.yaml` | canary (Argo Rollouts + analysis) |
| `values-bluegreen.yaml` | blue/green |

Failed canary analysis aborts the rollout (automatic rollback). Manual rollback: `./scripts/rollback.sh`.

## Cluster add-ons

Install once after AKS is up: [docs/install-addons.md](install-addons.md). Add-ons include:

- Gateway API CRDs + NGINX Gateway Fabric
- Argo CD
- Argo Rollouts
- kube-prometheus-stack, Tempo, Loki
- Kyverno
- Velero (Azure Blob + disk snapshots)
