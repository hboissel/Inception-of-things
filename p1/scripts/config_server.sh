#!/bin/sh

sudo apt update && sudo apt upgrade -y
sudo apt install -y curl

/usr/local/bin/k3s-uninstall.sh || echo "k3s is not installed"

curl -sfL https://get.k3s.io | K3S_TOKEN="$K_TOKEN" K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--node-ip=$SERVER_IP --flannel-iface=eth1" sh -s -