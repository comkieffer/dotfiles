#!/bin/bash
#
# Install the Fire Code font using the package manger if possible. Otherwise fall back to a manual 
# installation.

if $(dpkg -l | grep fonts-firacode); then
    sudo apt-get install fonts-firacode
else
    # Install script cribbed from: https://github.com/tonsky/FiraCode/wiki/Linux-instructions
    fonts_dir="${HOME}/.local/share/fonts"
    if [ ! -d ${fonts_dir} ]; then
        echo "Creating fonts directory $fonts_dir"
        mkdir -p ${fonts_dir}
    else
        echo "Found fonts dir $fonts_dir"
    fi

    for type in Bold Light Medium Regular Retina; do
        file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
        file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
        echo "Downloading font files ..."

        if [ ! -e ${file_path} ]; then
            wget -O ${file_path} ${file_url} > /dev/null
        fi;
    done

    echo "Updating font cache ..."
    fc-cache -f
fi
