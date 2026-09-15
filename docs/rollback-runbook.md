# Rollback runbook

Use this when a shop release is unhealthy after sync.

1. Confirm Argo CD application health: `argocd app get shop-prod`
2. Rolling: `kubectl -n shop rollout undo deployment/shop-backend`
3. Canary / blue-green: `kubectl argo rollouts undo shop-backend -n shop` or `./scripts/rollback.sh shop shop`
4. Smoke: `./scripts/smoke-test.sh https://shop.example.com/api/health`
5. If the cluster is the problem, restore from Velero: [disaster-recovery.md](disaster-recovery.md)
