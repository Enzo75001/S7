#!/bin/bash
set -e

echo "Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "Creating 'observability' namespace..."
kubectl create namespace observability --dry-run=client -o yaml | kubectl apply -f -

echo "Installing kube-prometheus-stack (Prometheus + Grafana)..."
helm upgrade --install monitor prometheus-community/kube-prometheus-stack \
  --namespace observability \
  --create-namespace \
  --wait

echo "Installing Loki Stack (Loki + Promtail)..."
helm upgrade --install loki grafana/loki-stack \
  --namespace observability \
  --set promtail.enabled=true \
  --wait

echo "Installing cert-manager (required for Jaeger Operator)..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.yaml
echo "Waiting for cert-manager webhook..."
kubectl wait --for=condition=available deployment/cert-manager-webhook -n cert-manager --timeout=120s

echo "Installing Jaeger Operator..."
kubectl apply -n observability -f https://github.com/jaegertracing/jaeger-operator/releases/latest/download/jaeger-operator.yaml

echo "Waiting for Jaeger Operator to be ready..."
kubectl wait --for=condition=available deployment/jaeger-operator -n observability --timeout=120s || echo "Warning: Jaeger Operator wait timed out"

echo "Creating Jaeger instance..."
cat <<EOF | kubectl apply -n observability -f -
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: simplest
spec:
  strategy: allinone
EOF

echo "Observability stack installation complete."
