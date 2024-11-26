#!/bin/bash

k3d cluster delete -a

echo "===== Executing part 1: Cluster creation ====="

k3d cluster create argocd-app-cluster --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer"

echo "===== Executing part 2: Deploy argocd and api ====="

kubectl create namespace argocd
kubectl create namespace dev

# argocd
kubectl apply -n argocd -k confs/argocd/kustom
echo "Waiting for ArgoCD to be ready..."
kubectl wait -n argocd --for=condition=available deployment/argocd-server --timeout=300s
echo "Creating Ingress and Application for ArgoCD"
kubectl apply -n argocd -f confs/argocd/ingress.yml

kubectl get all -A
