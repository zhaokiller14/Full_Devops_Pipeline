#!/bin/bash
# Exercise 4: Observability Stack Deployment
# Deploys Prometheus, Grafana, and AlertManager to Kubernetes
# Usage: ./deploy-monitoring.sh <namespace> [kubeconfig]

set -e

NAMESPACE=${1:-monitoring}
KUBECONFIG_FILE=${2:-$KUBECONFIG}

echo "=========================================="
echo "📊 Deploying Observability Stack"
echo "=========================================="
echo "Namespace: $NAMESPACE"
echo "Kubeconfig: $KUBECONFIG_FILE"
echo ""

# Step 1: Create namespace
echo "[1/6] Creating monitoring namespace..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f - --kubeconfig=$KUBECONFIG_FILE
echo "✅ Namespace created"
echo ""

# Step 2: Add Prometheus Community Helm repository
echo "[2/6] Adding Prometheus Community Helm repository..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
echo "✅ Helm repository added"
echo ""

# Step 3: Deploy kube-prometheus-stack
echo "[3/6] Deploying kube-prometheus-stack..."
helm install prometheus prometheus-community/kube-prometheus-stack \
  -f monitoring/prometheus-values.yaml \
  -n $NAMESPACE \
  --kubeconfig=$KUBECONFIG_FILE \
  --wait --timeout=10m
echo "✅ Prometheus stack deployed"
echo ""

# Step 4: Apply alerting rules
echo "[4/6] Applying AlertManager rules..."
kubectl apply -f monitoring/alerting-rules.yaml -n myapp --kubeconfig=$KUBECONFIG_FILE
echo "✅ Alerting rules applied"
echo ""

# Step 5: Apply AlertManager configuration
echo "[5/6] Applying AlertManager configuration..."
kubectl apply -f monitoring/alertmanager-config.yaml -n $NAMESPACE --kubeconfig=$KUBECONFIG_FILE
echo "✅ AlertManager configuration applied"
echo ""

# Step 6: Wait for components to be ready
echo "[6/6] Waiting for all components to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/instance=prometheus -n $NAMESPACE --timeout=300s --kubeconfig=$KUBECONFIG_FILE || true
echo "✅ Components ready"
echo ""

echo "=========================================="
echo "✅ Observability Stack Deployed Successfully!"
echo "=========================================="
echo ""
echo "🌐 Access URLs (port-forward required):"
echo "   Prometheus: http://localhost:9090"
echo "   Grafana: http://localhost:3000"
echo "   AlertManager: http://localhost:9093"
echo ""
echo "📝 Grafana Credentials:"
echo "   Username: admin"
echo "   Password: admin"
echo ""
echo "🔗 Quick Setup Port Forwarding:"
echo "   # Prometheus"
echo "   kubectl port-forward -n $NAMESPACE svc/prometheus-operated 9090:9090"
echo ""
echo "   # Grafana"
echo "   kubectl port-forward -n $NAMESPACE svc/prometheus-grafana 3000:80"
echo ""
echo "   # AlertManager"
echo "   kubectl port-forward -n $NAMESPACE svc/prometheus-alertmanager 9093:9093"
echo ""
echo "📚 Next Steps:"
echo "   1. Port-forward to Grafana (see above)"
echo "   2. Login with credentials above"
echo "   3. Import dashboard: monitoring/grafana-dashboard.json"
echo "   4. Monitor application metrics and alerts"
