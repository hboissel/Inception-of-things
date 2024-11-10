#!/bin/sh

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE='644' sh -s - --flannel-iface=eth1 --bind-address=${1}

echo "Initializing apps"
sleep 5

kubectl apply -f /opt/apps.yml -n apps && echo "Done."
