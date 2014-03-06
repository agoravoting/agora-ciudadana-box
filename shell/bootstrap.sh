#!/bin/bash

apt-get update

wget -qO /tmp/puppetlabs-release-wheezy.deb https://apt.puppetlabs.com/puppetlabs-release-wheezy.deb

dpkg -i /tmp/puppetlabs-release-wheezy.deb
rm /tmp/puppetlabs-release-wheezy.deb

apt-get update
apt-get install -y puppet aptitude realpath sudo

echo "saving path to manifests/init.pp so that backup script knows.."
SCRIPT_PATH=$(readlink -f "$0")
INIT_PATH=$(dirname $SCRIPT_PATH)/../manifests/init.pp
INIT_PATH=$(realpath $INIT_PATH)

echo "$INIT_PATH" > /root/.eo_puppet_manifests_path

echo "Puppet installed!"
