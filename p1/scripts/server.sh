#!/bin/bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s - --write-kubeconfig-mode=644 --node-ip ${1} --node-name ${2} --flannel-iface eth1 --token ${3}

if systemctl is-active --quiet k3s; then
    echo "K3s server started successfully."
    sudo chmod 644 /etc/rancher/k3s/k3s.yaml
else
    echo "K3s server failed to start. Checking logs..."
    journalctl -xeu k3s.service
fi