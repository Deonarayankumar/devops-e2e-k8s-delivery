# Disaster recovery

Daily Velero schedule (`gitops/platform/dr/velero-schedule.yaml`) backs up `shop` and `observability` to Azure Blob at 02:00 UTC. Retention is seven days.

## Restore a namespace

```bash
./scripts/restore.sh shop-daily-YYYYMMDDHHMMSS shop
```

## What is covered

- Kubernetes objects (Deployments, Services, Gateway/HTTPRoute, ConfigMaps)
- Persistent volume snapshots when the Azure plugin is installed
- Object storage for backup tarballs (`infra` storage module, `velero` container)

Secrets should be sourced from Key Vault / External Secrets in a real environment. This lab stores a placeholder `DATABASE_URL` Secret so the chart renders.

## Failover notes

1. Recreate the AKS cluster from Terraform if the control plane is lost.
2. Reinstall Velero with the same Blob container.
3. Restore the latest successful backup.
4. Confirm Argo CD self-heal matches Git.
