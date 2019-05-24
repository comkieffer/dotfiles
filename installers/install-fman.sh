#!/bin/sh

echo "Adding HQ fman's GPG key & sources.list ..."
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 9CFAF7EB 
echo "deb [arch=amd64] https://fman.io/updates/ubuntu/ stable main" | sudo tee /etc/apt/sources.list.d/fman.list

echo "Installing dependencies ..."
sudo apt-get install -qq apt-transport-https > /dev/null

echo "Installing fman ..."
sudo apt-get -qq update > /dev/null
sudo apt-get -qq install fman > /dev/null

