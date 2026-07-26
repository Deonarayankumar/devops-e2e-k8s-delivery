# Rollback Runbook

## When to rollback

- Smoke tests fail after Helm upgrade
- Error rate spike in Application Insights
- Pod crash loop after image tag change

## Steps

1. Identify release: `helm history order-service -n <namespace>`
2. Run rollback script:
   ```bash
   ./scripts/rollback.sh order-service staging
   # or pin revision:
   ./scripts/rollback.sh order-service production 4
   ```
3. Verify: `./scripts/smoke-test.sh <url>`
4. Post-incident: document root cause in team channel

## Pipeline rollback

Re-run Azure DevOps release with previous `Build.BuildId` image tag or trigger `helm rollback` from an approved ops job.
