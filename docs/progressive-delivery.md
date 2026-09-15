# Progressive delivery

## Rolling

Default for production. `maxUnavailable: 0` so capacity stays up during image replacement. Kubernetes Deployment rollback:

```bash
kubectl -n shop rollout undo deployment/shop-backend
```

## Canary

`values-staging.yaml` renders an Argo Rollout that shifts 20% then 50% of traffic. Prometheus analysis requires ≥95% success. A failed analysis pauses and then rolls back automatically.

## Blue/green

`values-bluegreen.yaml` keeps preview traffic on `shop-backend-preview` until promotion. `autoPromotionEnabled: false` so a human (or a pipeline) promotes after smoke tests.

```bash
kubectl argo rollouts promote shop-backend -n shop
```
