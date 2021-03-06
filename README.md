# Agora Ciudadana Puppet+Vagrant Box

puppet+vagrant setup for agora-ciudadana deployment

## Installation (vagrant+puppet)

### Install vagrant

* http://www.vagrantup.com

### Download the repository

* git clone https://github.com/agoravoting/agora-ciudadana-box.git

### Install the vb-guest plugin

* vagrant plugin install vagrant-vbguest

### Edit configuration

It has some sane defaults that makes the deploy work by default, but you can
edit the manifests/init.pp if you want. Take a look at the "Edit configuration"
part of the "Standalone installation" process for more details.

### Run

* vagrant up

Wait for the provisioning to finish

If you want to use it as is with the default configuration (which only makes if it's a test or development machine, otherwise it's completely UNSAFE), you need to add the following lines to /etc/hosts (from root user) on the host machine:

* echo "127.0.0.1 local.dev" >> /etc/hosts
* echo "127.0.0.1 sentry.local.dev" >> /etc/hosts
* echo "127.0.0.1 fnmt.local.dev" >> /etc/hosts

and you will have the service available at `http://local.dev:9443/` directly on your *host* machine, since the port is forwarded from the guest to your host.

### Accessing the vm

* vagrant ssh
* su -

### Applying puppet manually inside the vm

This is only needed if something went wrong or you want update the installation. Apply puppet manually with:

* cd /vagrant; sudo puppet apply manifests/init.pp --modulepath modules/

## Standalone installation (no vagrant, only puppet)

Apply puppet manually in a fresh Ubuntu 12.04 LTS (with no apache installed!) with:

* # apt-get install -y git-core pwgen
* # git clone https://github.com/agoravoting/agora-ciudadana-box.git
* # cd agora-ciudadana-box

### Edit configuration

It's now the time to edit manifests/init.pp. The variables are well documented,
so please take a while to read the comments.

You'll notice that the passwords are always marked as <PASSWORD>. You can
automatically populate each password with a different value executing the
following script:

* # shell/set_passwords.sh manifests/init.pp

### Execute deployment

Just execute:

* # sh shell/bootstrap.sh
* # puppet apply manifests/init.pp --modulepath modules/

If you want to log the output to a file use

* # puppet apply manifests/init.pp --modulepath modules/ | tee /tmp/puppet.log

### Troubleshooting

## If you get the following error during provisioning:

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

## If you get the following error during provisioning:

Error: /etc/apt/sources.list contains a cdrom source; not installing.  Use 'allowcdrom' to override this failure.

You need to

* vi /etc/apt/sources.list

Comment out entries beginning with "deb cdrom:..."

Save and retry puppet provisioning
