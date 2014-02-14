# Agora Ciudadana Puppet+Vagrant Box

puppet+vagrant setup for agora-ciudadana deployment

## Installation (vagrant+puppet)

### Install vagrant

* http://www.vagrantup.com

### Download the repository

* git clone https://github.com/agoraciudadana/agora-ciudadana-box.git

### Run

* vagrant up

Wait for the provisioning to finish, and you will have the service available at `http://127.0.0.1:8000/` directly on your *host* machine, since the port is forwarded from the guest to your host.

### Accessing the vm

* vagrant ssh
* sudo -s

### Applying puppet manually inside the vm

This is only needed if something went wrong or you want update the installation. Apply puppet manually with:

* cd /vagrant; sudo puppet apply manifests/init.pp --modulepath modules/

## Standalone installation (no vagrant, only puppet)

* git clone https://github.com/agoraciudadana/agora-ciudadana-box.git
* cd agora-ciudadana-box
* sudo shell/bootstrap.sh
* sudo puppet apply manifests/init.pp --modulepath modules/