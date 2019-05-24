#!/bin/bash

echo "Updating package list & updating out-of-date packages ..."
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null

echo "Installing common packages ..."
sudo apt-get install -qq build-essential htop stow > /dev/null

has_i3=$(which i3 > /dev/null; echo $?)
if [ $has_i3 -eq 0 ]; then 
    echo "Installing i3 related packages ..."
    sudo apt-get install -qq arandr autorandr
fi

