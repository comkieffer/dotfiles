#!/bin/sh

echo "Adding Bintray's GPGP key & sources.list ..."
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61  > /dev/null
echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list

echo "Installing Etcher ..."
sudo apt-get -qq update > /dev/null
sudo apt-get -qq install balena-etcher-electron > /dev/null
