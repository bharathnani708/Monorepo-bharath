#!/usr/bin/env bash
set -euo pipefail

# REPLACE this to your actual GitHub username/org
: "${GH_OWNER:=YOUR_USER}"

NAMESPACE=dev
helm upgrade --install api-gateway deploy/charts/api-gateway \
  -n "$NAMESPACE" \
  --set image.repository="ghcr.io/${GH_OWNER}/api-gateway-node" \
  --set image.tag="dev"

helm upgrade --install payments deploy/charts/payments \
  -n "$NAMESPACE" \
  --set image.repository="ghcr.io/${GH_OWNER}/payments-python" \
  --set image.tag="dev"

helm upgrade --install orders deploy/charts/orders \
  -n "$NAMESPACE" \
  --set image.repository="ghcr.io/${GH_OWNER}/orders-java" \
  --set image.tag="dev"

# Simple Ingress for demo (one host per service via path)
cat <<'YAML' | kubectl -n "$NAMESPACE" apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - http:
      paths:
      - path: /api
        pathType: Prefix
        backend: { service: { name: api-gateway, port: { number: 80 } } }
      - path: /pay
        pathType: Prefix
        backend: { service: { name: payments, port: { number: 80 } } }
      - path: /ord
        pathType: Prefix
        backend: { service: { name: orders, port: { number: 80 } } }
YAML

echo "⏳ Waiting for ingress controller..."
kubectl -n ingress-nginx rollout status deploy/ingress-nginx-controller --timeout=120s || true

echo "✅ Deployed. Test URLs:"
minikube service list | sed -n '1,200p'
echo
MINI_IP=$(minikube ip)
echo "Health checks:"
echo "  curl -s http://${MINI_IP}/api/healthz"
echo "  curl -s http://${MINI_IP}/pay/healthz"
echo "  curl -s http://${MINI_IP}/ord/healthz"
