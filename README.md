# Agora Ciudadana Puppet+Vagrant Box

puppet+vagrant setup for agora-ciudadana deployment

## Installation (vagrant+puppet)

### Install vagrant

* http://www.vagrantup.com

### Download the repository

* git clone https://github.com/agoraciudadana/agora-ciudadana-box.git

### Install the vb-guest plugin

* vagrant plugin install vagrant-vbguest

### Run

* vagrant up

Wait for the provisioning to finish

If you want to use it as is with the default configuration (which only makes if it's a test or development machine, otherwise it's completely UNSAFE), you need to add the following lines to /etc/hosts (from root user):

* echo "127.0.0.1 local.dev" > /etc/hosts
* echo "127.0.0.1 sentry.local.dev" > /etc/hosts
* echo "127.0.0.1 fnmt.local.dev" > /etc/hosts

and you will have the service available at `http://local.dev:9443/` directly on your *host* machine, since the port is forwarded from the guest to your host.

### Accessing the vm

* vagrant ssh
* sudo -s

### Applying puppet manually inside the vm

This is only needed if something went wrong or you want update the installation. Apply puppet manually with:

* cd /vagrant; sudo puppet apply manifests/init.pp --modulepath modules/

## Standalone installation (no vagrant, only puppet)

Apply puppet manually in a fresh Debian 7.4 (with no apache installed!) with:

* sudo apt-get install -y git-core
* git clone https://github.com/agoraciudadana/agora-ciudadana-box.git
* cd agora-ciudadana-box

Edit manifests/init.pp accordingly, then:

* sudo sh shell/bootstrap.sh
* sudo puppet apply manifests/init.pp --modulepath modules/

### Troubleshooting

If you get the following error during provisioning:

Failed to mount folders in Linux guest. This is usually because
the "vboxsf" file system is not available. Please verify that
the guest additions are properly installed in the guest and
can work properly....

You need to

* vagrant ssh
* sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions

back on the host

* vagrant reload

This has been seen on virtualbox 4.3.10. See https://github.com/mitchellh/vagrant/issues/3341