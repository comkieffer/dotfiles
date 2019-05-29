#!/bin/sh

set -e
distribution=$(lsb_release -r | cut -f 2)

echo "Downloding GPG key for Owncloud repository ..."
wget -qO - https://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_${distribution}/Release.key | sudo apt-key add - > /dev/null
echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_${distribution}/ /" | sudo tee /etc/apt/sources.list.d/isv:ownCloud:desktop.list

echo " Installing owncloud client ..."
sudo apt-get -qq update > /dev/null
sudo apt-get -qq install owncloud-client > /dev/null

set +e

