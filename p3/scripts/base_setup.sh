#!/bin/bash

echo "===== Executing part 1: k3d setup ====="

sudo apt update -y
sudo apt upgrade -y

if ! grep -q "127.0.0.1 argocd.local" /etc/hosts; then
    echo -e "127.0.0.1 argocd.local\n127.0.0.1 api.local" | sudo tee -a /etc/hosts
fi

# install docker
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#setup current user in docker group (remove the need of sudo)
sudo usermod -aG docker $USER
# need to reboot here.
docker run hello-world

#setup kubectl
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

#setup k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
