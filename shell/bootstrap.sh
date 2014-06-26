#!/bin/bash

apt-get update

wget -qO /tmp/puppetlabs-release-wheezy.deb https://apt.puppetlabs.com/puppetlabs-release-wheezy.deb

dpkg -i /tmp/puppetlabs-release-wheezy.deb
rm /tmp/puppetlabs-release-wheezy.deb

apt-get update
apt-get install -y puppet aptitude realpath sudo libssl-dev libbz2-dev pwgen build-essential

echo "Installing python 3.3.."
wget -qO /tmp/Python-3.3.5.tar.xz http://www.python.org/ftp/python/3.3.5/Python-3.3.5.tar.xz
cd /tmp
tar xJf ./Python-3.3.5.tar.xz
cd ./Python-3.3.5/Modules/zlib
./configure
make && make install
cd /tmp/Python-3.3.5
./configure --prefix=/opt/python3.3
make && make install
ln -s /opt/python3.3/bin/python3.3 /usr/bin/python3.3
wget https://bootstrap.pypa.io/ez_setup.py -O - | python3.3

echo "Saving path to manifests/init.pp so that backup script knows.."
SCRIPT_PATH=$(realpath "$0")
INIT_PATH=$(dirname $SCRIPT_PATH)/../manifests/init.pp
INIT_PATH=$(realpath $INIT_PATH)

echo "$INIT_PATH" > /root/.eo_puppet_manifests_path

echo "Puppet installed!"
