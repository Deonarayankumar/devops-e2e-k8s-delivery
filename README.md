# Production-Grade Kubernetes Platform

Flagship lab (**July 2026 – August 2026**): Terraform on Azure, GitOps with Argo CD, Gateway API, observability, and automated disaster recovery — not a single “app on Kubernetes” deploy.

Architecture notes: [docs/architecture.md](docs/architecture.md) · DR: [docs/disaster-recovery.md](docs/disaster-recovery.md) · Rollouts: [docs/progressive-delivery.md](docs/progressive-delivery.md)

## What this demonstrates

- VNet with public and private subnets, NAT, NSGs, AKS, PostgreSQL Flexible Server, Blob storage, DNS, and GitHub OIDC identity
- Kubernetes Deployments, Services, ConfigMaps, Secrets, Gateway API HTTPRoutes, HPA, PDBs, probes, requests/limits, namespaces, RBAC, NetworkPolicies
- CI: GitHub Actions → tests → image build → Trivy → pin Helm tags
- CD: Argo CD syncs Git to the cluster; rolling, canary, and blue/green strategies with automatic rollback on failed analysis
- OpenTelemetry → Tempo, Prometheus → Grafana, Slack/PagerDuty contact points
- Kyverno admission policy and Velero scheduled backups

GitOps adoption context: CNCF reported GitOps principles in 77% of surveyed organizations (2025); Argo CD’s 2025 end-user survey reported it in nearly 60% of represented Kubernetes clusters. Gateway API is the Kubernetes project’s successor to Ingress for richer routing.

## Repository layout

```
apps/backend          FastAPI order API + tests
apps/frontend         nginx static UI
infra/bootstrap       Azure storage for Terraform state
infra/modules         networking, aks, database, storage, identity, dns
infra/envs/lab        composition
charts/shop           Helm chart (app desired state)
gitops/argocd         Argo CD Applications
gitops/platform       OTel, alerting, Kyverno, Velero
.github/workflows     governance + CI
```

Application vs infrastructure are separate trees so they can be split into two GitHub repos later without rewriting the delivery model.

## Local API

```bash
cd apps/backend
python -m pip install -r requirements-dev.txt
pytest -q
docker compose up --build
./scripts/smoke-test.sh http://localhost:8080/health
```

## Deploy infrastructure (Azure)

NAT, AKS, and PostgreSQL incur charges. Destroy the stack when the demo is finished.

1. `cd infra/bootstrap && terraform init && terraform apply`
2. Copy `infra/envs/lab/backend.hcl.example` to `backend.hcl` and fill storage outputs.
3. `cd infra/envs/lab && terraform init -backend-config=backend.hcl && terraform apply`
4. `az aks get-credentials -g <rg> -n <aks>`
5. Install Gateway API, NGINX Gateway Fabric, Argo CD, Argo Rollouts, kube-prometheus-stack, Tempo, Kyverno, and Velero (commands in [docs/architecture.md](docs/architecture.md)).
6. `kubectl apply -f gitops/argocd/`

Pushes to `main` run CI. A successful image build pins `charts/shop/values.yaml` tags; Argo CD applies the change.

## Observable result

- `GET /health` on the backend returns 200
- `GET /ready` is 200 when Postgres is reachable
- Helm template produces Gateway and HTTPRoute objects
- Trivy fails the pipeline on unfixed CRITICAL/HIGH findings

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `/ready` is 503 | Missing `DATABASE_URL` or NSG | Confirm data-subnet rule and Secret |
| Argo CD OutOfSync | Helm values not committed | Check CI GitOps pin job |
| Canary stuck | Analysis query empty | Confirm ServiceMonitor / Prometheus labels |
| Restore empty | Wrong backup name | `velero backup get` then `scripts/restore.sh` |

## Related labs

Part of the [DevOps Portfolio Hub](https://github.com/Deonarayankumar/devops-portfolio-hub). Complements `devops-kubernetes-lab` (manifests) and `devops-e2e-aws-fargate-platform` (AWS containers without Kubernetes).
