#!/bin/bash

apt-get update

wget -qO /tmp/puppetlabs-release-wheezy.deb https://apt.puppetlabs.com/puppetlabs-release-wheezy.deb

dpkg -i /tmp/puppetlabs-release-wheezy.deb
rm /tmp/puppetlabs-release-wheezy.deb

apt-get update
apt-get install -y puppet aptitude realpath sudo libssl-dev libbz2-dev pwgen build-essential supervisor

echo "Installing python 3.3.."
wget -qO /tmp/Python-3.3.5.tar.xz http://www.python.org/ftp/python/3.3.5/Python-3.3.5.tar.xz
cd /tmp
(md5sum Python-3.3.5.tar.xz | grep b2a4df195d934e5b229e8328ca864960) || (echo "invalid hash for Python-3.3.5.tar.xz" && exit 1)
tar xJf ./Python-3.3.5.tar.xz
cd ./Python-3.3.5/Modules/zlib
./configure
make && make install
cd /tmp/Python-3.3.5
./configure --prefix=/opt/python3.3
make && make install
ln -s /opt/python3.3/bin/python3.3 /usr/bin/python3.3
rm /tmp/Python-3.3.5.tar.xz

echo "Installing ez_setup.py.."
wget -q0 /tmp/ez_setup.py https://bootstrap.pypa.io/ez_setup.py
cd /tmp
(md5sum ez_setup.py | grep 3568a316988ea5d6e6583cd4645e50d6) || (echo "invalid hash for ez_setup.py" && exit 1)
python3.3 ez_setup.py

echo "Installing supervisor 3.0r1-1.."
wget -qO /tmp/supervisor_3.0r1-1_all.deb http://ftp.br.debian.org/debian/pool/main/s/supervisor/supervisor_3.0r1-1_all.deb
cd /tmp
(md5sum supervisor_3.0r1-1_all.deb | grep c2e8b72bf8ba3d0b68f3ba14f9f6d15d) || (echo "invalid hash for supervisor_3.0r1-1_all.deb" && exit 1)
dpkg -i supervisor_3.0r1-1_all.deb
rm /tmp/supervisor_3.0r1-1_all.deb

echo "Saving path to manifests/init.pp so that backup script knows.."
SCRIPT_PATH=$(realpath "$0")
INIT_PATH=$(dirname $SCRIPT_PATH)/../manifests/init.pp
INIT_PATH=$(realpath $INIT_PATH)

echo "$INIT_PATH" > /root/.eo_puppet_manifests_path

echo "Puppet installed!"
