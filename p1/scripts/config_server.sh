#!/bin/sh

sudo apt update && sudo apt upgrade -y
sudo apt install -y curl

/usr/local/bin/k3s-uninstall.sh || echo "k3s is not installed"

curl -sfL https://get.k3s.io | K3S_TOKEN="$TOKEN" K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--bind-address=$SERVER_IP --flannel-iface=eth1" sh -s -