# -*- mode: ruby -*-
# vi: set ft=ruby :

SERVER_NAME = "InceptionEval"

$script = <<-SCRIPT
sudo apt-get update -y
sudo apt-get install git vim wget curl -y
sudo apt-get install --no-install-recommends ubuntu-desktop -y
sudo apt-get install -y --no-install-recommends virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
sudo apt-get install firefox -y
sudo apt-get install curl wget gnupg2 lsb-release zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

wget https://releases.hashicorp.com/vagrant/2.4.3/vagrant_2.4.3_linux_amd64.zip
unzip vagrant_2.4.3_linux_amd64.zip
sudo mv vagrant /usr/local/bin/

curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/vbox.gpg
curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt-get update
sudo apt-get install -y linux-headers-$(uname -r) dkms
sudo apt-get install virtualbox-7.0 -y
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 8
    vb.memory = "10240"
  end

  config.vm.define SERVER_NAME do |machine|
    machine.vm.hostname = SERVER_NAME
    machine.vm.provider "virtualbox" do |vb|
      vb.name = SERVER_NAME
      vb.gui = true
      vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
    end
    machine.vm.provision "shell", inline: $script
  end
end
