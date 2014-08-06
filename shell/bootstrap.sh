#!/bin/bash

apt-get update

apt-get install -y puppet realpath libssl-dev libbz2-dev pwgen build-essential supervisor python3-setuptools

echo "Installing supervisor 3.0r1-1.."
[ -f supervisor_3.0r1-1_all.deb  ] || (wget -qO supervisor_3.0r1-1_all.deb http://launchpadlibrarian.net/173936425/supervisor_3.0r1-1_all.deb)
(md5sum supervisor_3.0r1-1_all.deb | grep 368bfa94087bdc5eca01eae1ecc87335) || (echo "invalid hash for supervisor_3.0r1-1_all.deb" && exit 1)
dpkg -i supervisor_3.0r1-1_all.deb
rm supervisor_3.0r1-1_all.deb

echo "Saving path to manifests/init.pp so that backup script knows.."
SCRIPT_PATH=$(realpath "$0")
INIT_PATH=$(dirname $SCRIPT_PATH)/../manifests/init.pp
INIT_PATH=$(realpath $INIT_PATH)

echo "$INIT_PATH" > /root/.eo_puppet_manifests_path

echo "Puppet installed!"
