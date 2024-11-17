
#!/bin/bash

cd /vagrant

kubectl create namespace gitlab

echo "Creating Ingress for Gitlab"
kubectl apply -n gitlab -f confs/gitlab

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --namespace gitlab \
  --set global.edition=ce \
  --set global.hosts.domain=local \
  --set global.hosts.externalIP=$SERVER_IP \
  --set certmanager.install=false \
  --set nginx-ingress.enabled=false \
  --set global.ingress.configureCertmanager=false \
  --set gitlab-runner.install=false

kubectl wait -n gitlab --for=condition=available deployment.apps/gitlab-webservice-default --timeout=300s

export GITLAB_PASSWORD=$(kubectl -n gitlab get secret gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode)
echo "Gitlab root password: $GITLAB_PASSWORD"
echo "Gitlab URL: https://gitlab.local"


#https://forum.gitlab.com/t/gitlab-on-kubernetes-behind-traefk-ingressroutes-external-cert-manager/98019/2