#!/bin/bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://${1}:6443 --node-name ${2} --node-ip ${3} --flannel-iface eth1 --token ${4}" sh -s -
