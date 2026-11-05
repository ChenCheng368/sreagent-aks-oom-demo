#!/usr/bin/env bash
# Runs a command in the AKS cluster with `az aks command invoke` and fails if the command fails.
# az itself exits 0 even when kubectl fails, so the exit code is read from the JSON result.
# Usage: aks-invoke.sh "<command>" [folder-to-attach]
set -euo pipefail

args=(--resource-group "$AKS_RESOURCE_GROUP" --name "$AKS_CLUSTER_NAME" --command "$1" --output json)
if [ -n "${2:-}" ]; then
  args+=(--file "$2")
fi

result=$(az aks command invoke "${args[@]}")
echo "$result" | jq -r '.logs'
exit "$(echo "$result" | jq -r '.exitCode')"
