#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:?usage: smoke-test.sh <base-url>}"

curl -fsS "${BASE_URL}/health" | grep -q '"status":"ok"'
curl -fsS -X POST "${BASE_URL}/orders" \
  -H "Content-Type: application/json" \
  -d '{"sku":"K8S-SMOKE","quantity":1}' | grep -q '"status":"accepted"'
echo "K8s smoke tests passed"
