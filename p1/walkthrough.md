# my walkthrough

base machine: `ubuntu24`

## Install needed stuff (vagrant virtualbox etc):

### helpers:
create vagrant vms:
```bash
vagrant up
```

destroy vagrant vms:
```bash
vagrant destroy
```

```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install @development-tools -y
sudo apt install kernel-headers kernel-devel dkms vagrant -y
```

chosen latest LTS image as the subject ask: *debian12* otherwise i would have chosen fedora cloud 41 but not available on the
[hashicorp cloud](https://portal.cloud.hashicorp.com/vagrant/discover/generic/debian12)
### init vagrant file:
```bash
vagrant init
```
### add vagrant box:
```bash
vagrant box add generic/debian12 --provider=virtualbox
```
