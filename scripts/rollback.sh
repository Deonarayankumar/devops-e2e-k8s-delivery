#!/usr/bin/env bash
set -euo pipefail
NS="${1:-shop}"
RELEASE="${2:-shop}"
echo "Rolling back Helm release ${RELEASE} in ${NS}"
helm rollback "${RELEASE}" -n "${NS}"
kubectl argo rollouts undo shop-backend -n "${NS}" || true
