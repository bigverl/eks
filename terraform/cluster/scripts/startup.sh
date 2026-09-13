#!/usr/bin/env bash
# Run after every `terraform destroy` -> `apply` cycle to get the cluster
# and the ALB controller back to a working state.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="$SCRIPT_DIR/.."

CLUSTER_NAME="pokefinder-eks"
REGION="us-east-1"
VALUES_FILE="alb-controller-values.yaml"

cd "$TF_DIR"

echo "==> pointing kubectl at the cluster"
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION"

echo "==> waiting for nodes to be Ready"
kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo "==> waiting for baseline addons in kube-system"
kubectl wait --for=condition=Ready pods --all -n kube-system --timeout=300s

echo "==> fetching fresh VPC ID (a new VPC is created on every apply)"
VPC_ID="$(terraform output -raw vpc_id)"
echo "    vpc_id = $VPC_ID"
sed -i "s/^vpcId:.*/vpcId: $VPC_ID/" "$VALUES_FILE"

echo "==> installing/upgrading the ALB controller"
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system -f "$VALUES_FILE"

echo "==> waiting for the controller to be Ready"
kubectl wait --for=condition=Ready pods -n kube-system \
  -l app.kubernetes.io/name=aws-load-balancer-controller --timeout=180s

echo "==> applying hello-example test manifests"
kubectl apply -f ../../manifests/hello-example/

echo "==> waiting for the ALB to be provisioned (can take a couple minutes)"
until kubectl get ingress hello -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null | grep -q .; do
  sleep 5
done

echo "==> done"
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
echo "    hello ALB: $(kubectl get ingress hello -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"
