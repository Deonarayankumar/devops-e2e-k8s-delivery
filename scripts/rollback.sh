#!/usr/bin/env bash
set -euo pipefail

RELEASE="${1:-order-service}"
NAMESPACE="${2:-staging}"
REVISION="${3:-}"

if [[ -z "${REVISION}" ]]; then
  echo "Rolling back ${RELEASE} in ${NAMESPACE} to previous revision"
  helm rollback "${RELEASE}" -n "${NAMESPACE}"
else
  echo "Rolling back ${RELEASE} in ${NAMESPACE} to revision ${REVISION}"
  helm rollback "${RELEASE}" "${REVISION}" -n "${NAMESPACE}"
fi

helm history "${RELEASE}" -n "${NAMESPACE}" | tail -5
