#!/bin/sh

export SERVER_IP=192.168.56.110

cd /vagrant

k3d cluster delete -a

####### CLUSTER CONFIG FOR NODEPORT ########
# k3d cluster create argocd-app-cluster --api-port 127.0.0.1:6443 \
#     --agents 1 \
#     -p "8888:31888@agent:0" \
#     -p "80:30080@agent:0" \
#     -p "443:30443@agent:0" \
#     --wait \
#     --kubeconfig-update-default \
#     --kubeconfig-switch-context

####### CLUSTER CONFIG FOR LOADBALANCER ########
k3d cluster create argocd-app-cluster --api-port 127.0.0.1:6443 \
    --agents 1 \
    -p "8888:31888@agent:0" \
    -p "80:80@loadbalancer" \
    -p "443:443@loadbalancer" \
    --wait \
    --kubeconfig-update-default \
    --kubeconfig-switch-context

kubectl create namespace argocd
kubectl create namespace dev

######## INSTALL ARGOCD FULL ########
### nodePort install
# kubectl -n argocd apply -f confs/nodePort-argocd.yaml
### Ingress install
kubectl -n argocd apply -f confs/ingress-argocd.yaml
### custom install without tls and local file
# kubectl -n argocd apply -f confs/install-argocd.yaml
#### normal install
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
### to disable ssl with configmap
kubectl apply -n argocd -f confs/argocd-cmd-params-cm.yaml

######## INSTALL ARGOCD CORE ########
# export ARGOCD_VERSION="v2.12.7"
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/$ARGOCD_VERSION/manifests/core-install.yaml

sleep 2

echo "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=120s

##### Setup the app for ArgoCD
kubectl -n argocd apply -f confs/app-argocd.yaml

#### Using the cli tool
# argocd --insecure login $SERVER_IP --username admin --password $ARGODC_PASSWORD <<EOF
# y
# EOF

# kubectl config set-context --current --namespace=argocd
# argocd app create app --insecure --repo https://github.com/hboissel/argocd-app-hboissel.git \
#     --path . \
#     --dest-server https://kubernetes.default.svc \
#     --dest-namespace dev
# argocd app sync app --insecure
# argocd app set app --insecure --sync-option ApplyOutOfSyncOnly=true \
#     --sync-policy automated \
#     --auto-prune \
#     --allow-empty \
#     --self-heal

export ARGODC_PASSWORD=$(
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    echo
)
# print credentials
echo "ArgoCD admin password: $ARGODC_PASSWORD"
unset ARGODC_PASSWORD
