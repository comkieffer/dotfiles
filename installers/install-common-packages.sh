#!/bin/bash

echo "Updating package list & updating out-of-date packages ..."
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null

echo "Installing common packages ..."
sudo apt-get install -qq build-essential htop stow direnv > /dev/null

echo "Installing terminal fun packages ..."
sudo apt-get install -qq tmux vim > /dev/null
