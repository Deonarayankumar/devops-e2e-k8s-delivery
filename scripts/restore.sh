#!/usr/bin/env bash
set -euo pipefail
BACKUP="${1:?backup name}"
NS="${2:-shop}"
velero restore create "restore-${BACKUP}" --from-backup "${BACKUP}" --include-namespaces "${NS}" --wait
kubectl -n "${NS}" get deploy,svc,httproute
