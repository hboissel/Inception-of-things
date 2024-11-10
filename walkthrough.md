# my walkthrough

base machine: `ubuntu24`

## base machine setup:

```bash
sudo apt update -y && apt upgrade -y
sudo apt install curl wget gnupg2 lsb-release zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```

check if virtualisation is correctly active:
```bash
lsmod | grep kvm
```

install vbox:
```bash
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/vbox.gpg
curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install -y linux-headers-$(uname -r) dkms
sudo apt install virtualbox-7.0 -y
```

### helpers:
create vagrant vms:
```bash
vagrant up
```

destroy vagrant vms:
```bash
vagrant destroy
```

close a vagrant vm
```bash
vagrant halt
```

reload a vagrant vm (halt+up)
```bash
vagrant reload
```

check vagrant vm status
```bash
vagrant status
```

run provision vm scripts
```bash
vagrant provision
```

list virtualbox vms
```bash
VBoxManage list vms
```

## Part1
chosen latest LTS image as the subject ask: *debian12*
[hashicorp cloud](https://portal.cloud.hashicorp.com/vagrant/discover/generic/debian12)

`--flannel-iface eth1` make k3s use the primary iface

bootstrap the k3s cluster
```bash
TOKEN=mytoken vagrant up
```

check the k3s cluster
```bash
vagrant ssh ebouvierS

vagrant@ebouvierS:~$ kubectl get nodes -o wide
NAME         STATUS   ROLES                  AGE    VERSION        INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
ebouviers    Ready    control-plane,master   9m6s   v1.30.6+k3s1   192.168.56.110   <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-17-amd64   containerd://1.7.22-k3s1
ebouviersw   Ready    <none>                 7m8s   v1.30.6+k3s1   192.168.56.111   <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-17-amd64   containerd://1.7.22-k3s1
```


