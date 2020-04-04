#!/bin/bash

tarball_path=$(mktemp zotero-tarball-XXXXX)
download_url=" https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64"
install_dir="/opt/zotero"

set +e

echo "Downloading tarball ..."
wget --content-disposition --quiet  $download_url --output-document $tarball_path > /dev/null

echo "Unpacking Zotero ..."o
sudo mkdir $install_dir
sudo tar jxf $tarball_path -C $install_dir --strip-components=1

echo "Updating permissions on Zotero install folder"
sudo chown -R $(whoami):$(woami) $install_dir

echo "Creating symlinks ..."
ln -s ${install_dir}/zotero.desktop ~/.local/share/applications/zotero.desktop

echo "removving tarball ..."
rm $tarball_path

set -e
