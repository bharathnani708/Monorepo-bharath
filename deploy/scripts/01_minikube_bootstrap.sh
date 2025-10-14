#!/usr/bin/env bash
set -euo pipefail

# Install kubectl if missing
if ! command -v kubectl >/dev/null 2>&1; then
  curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/$(uname | tr '[:upper:]' '[:lower:]')/amd64/kubectl"
  chmod +x kubectl && sudo mv kubectl /usr/local/bin/
fi

# Install Helm if missing
if ! command -v helm >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Install minikube if missing
if ! command -v minikube >/dev/null 2>&1; then
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-$(uname | tr '[:upper:]' '[:lower:]')-amd64
  chmod +x minikube && sudo mv minikube /usr/local/bin/
fi

# Start minikube with enough resources
minikube start --cpus=4 --memory=6g --kubernetes-version=stable

# Enable ingress addon
minikube addons enable ingress

kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
echo "✅ Minikube ready. Current context:"
kubectl config current-context
kubectl get nodes -o wide
