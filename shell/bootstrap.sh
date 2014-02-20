#!/bin/bash

apt-get install update
apt-get install aptitude

wget -qO /tmp/puppetlabs-release-wheezy.deb https://apt.puppetlabs.com/puppetlabs-release-wheezy.deb

dpkg -i /tmp/puppetlabs-release-wheezy.deb
rm /tmp/puppetlabs-release-wheezy.deb

apt-get update
apt-get install --force-yes puppet

echo "Puppet installed!"
