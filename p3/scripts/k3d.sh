#!/bin/bash

echo "===== Executing part 1: Cluster creation ====="

k3d cluster create iot --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-arg="--disable=traefik@server:*" || true #disable traefik (we will deploy our own.)

#install traefik v3
# install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm repo add traefik https://traefik.github.io/traefik-helm-chart
helm repo update
# helm upgrade traefik traefik/traefik -n kube-system -f values.yaml
helm install traefik traefik/traefik -n kube-system --create-namespace -f $PWD/confs/traefik/values.yaml
kubectl wait -n kube-system --for=condition=available deployment/traefik --timeout=300s
kubectl get pods -n kube-system -l app.kubernetes.io/name=traefik
kubectl get svc -n kube-system -l app.kubernetes.io/name=traefik

#ingress for traefik dashboard
kubectl apply -n kube-system -f $PWD/confs/traefik/ingress.yaml

echo "===== Executing part 3: Deploy argocd and api ====="

#generate certs
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout selfsigned.key \
  -out selfsigned.crt \
  -days 365 \
  -config $PWD/scripts/openssl.cnf


kubectl create secret tls traefik-cert-argocd --cert=selfsigned.crt --key=selfsigned.key -n kube-system

# argocd
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -k $PWD/confs/argocd/kustom
kubectl wait -n argocd --for=condition=available deployment/argocd-server --timeout=300s
kubectl apply -n argocd -f $PWD/confs/argocd/argocd_ingress.yaml
#show argocd passwd
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo

# dev api
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f $PWD/confs/api
kubectl wait -n dev --for=condition=available deployment/api --timeout=300s

kubectl get all -A
