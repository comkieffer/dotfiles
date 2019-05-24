#!/bin/sh

echo "Adding SublimeHQ GPGP key & sources.list ..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

echo "Installing dependencies ..."
sudo apt-get install -qq apt-transport-https > /dev/null

echo "Installing Sublime Text ..."
sudo apt-get -qq update > /dev/null
sudo apt-get -qq install sublime-text > /dev/null

