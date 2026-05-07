#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${DD_API_KEY:-}" ]]; then
  echo "DD_API_KEY must be set in the environment"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLUSTER_TOKEN="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32)"
FW_VER="v0.17.0"

curl -sL "https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${FW_VER}/install.sh" | bash -s "${FW_VER}"
kubectl create -f https://operatorhub.io/install/datadog-operator.yaml
kubectl get csv -n operators

kubectl create secret generic datadog-auth-token \
  --from-literal=token="${CLUSTER_TOKEN}" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic datadog-api-key \
  --from-literal=api-key="${DD_API_KEY}" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f "${SCRIPT_DIR}/datadog-cluster-agent_service.yaml"
kubectl apply -f "${SCRIPT_DIR}/cluster-agent.yaml"
