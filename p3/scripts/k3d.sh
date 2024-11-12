#!/bin/bash

echo "===== Executing part 1: Cluster creation ====="

k3d cluster create iot --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" || true

echo "===== Executing part 2: Deploy argocd and api ====="

# argocd
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -k $PWD/confs/argocd/kustom
kubectl wait -n argocd --for=condition=available deployment/argocd-server --timeout=300s
kubectl apply -n argocd -f $PWD/confs/argocd

#show argocd passwd
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo

# dev api
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f $PWD/confs/api

kubectl get all -A
