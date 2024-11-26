
#!/bin/bash

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
  --set gitlab-runner.install=false \
  --set gitlab.webservice.maxReplicas=1 \
  --set gitlab.webservice.minReplicas=1 \
  --set gitlab.sidekiq.maxReplicas=1 \
  --set gitlab.sidekiq.minReplicas=1 \
  --set gitlab.gitlab-shell.maxReplicas=1 \
  --set gitlab.gitlab-shell.minReplicas=1 \
  --set prometheus.install=false

echo "Wait for Gitlab to be ready"
kubectl wait -n gitlab --for=condition=available deployment.apps/gitlab-webservice-default --timeout=300s

