#!/usr/bin/env bash
set -euo pipefail

# Requires a GitHub Personal Access Token with read:packages
# Usage: GH_USER="youruser" GH_PAT="token" ./02_k8s_pull_secret_ghcr.sh

: "${GH_USER:?Set GH_USER=your-github-username}"
: "${GH_PAT:?Set GH_PAT=your-personal-access-token}"

kubectl -n dev delete secret ghcr-creds >/dev/null 2>&1 || true
kubectl -n dev create secret docker-registry ghcr-creds \
  --docker-server=ghcr.io \
  --docker-username="$GH_USER" \
  --docker-password="$GH_PAT" \
  --docker-email="noreply@example.com"

# Default service account uses the pull secret
kubectl -n dev patch serviceaccount default -p '{"imagePullSecrets":[{"name":"ghcr-creds"}]}' || true
echo "✅ Created image pull secret 'ghcr-creds' in namespace dev"
