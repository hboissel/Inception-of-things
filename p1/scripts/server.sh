#!/bin/sh

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s - \
--write-kubeconfig-mode=644 \
--node-ip ${1} \
--node-name ${2} \
--flannel-iface eth1 \
--token ${3}

if service k3s status | grep -q "started"; then
    echo "K3s server started successfully."
    chmod 644 /etc/rancher/k3s/k3s.yaml
else
    echo "K3s server failed to start. Checking logs..."
    cat /var/log/k3s-service.log
fi
