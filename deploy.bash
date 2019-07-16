#!/bin/bash
#
# Install all the dotfiles in one go with GNU Stow
#

set -e

INSTALLATION_DIR="${HOME}"
STOW_COMMAND="stow --target ${INSTALLATION_DIR} --verbose --restow"

function install {
    echo ""
    echo "Installing $1 files ... "
    $STOW_COMMAND $1
}

# Start by creating the directories we need. 
# If we don't create bin/ for example it will be simlinked in which will be a 
# hassle easch time we add a script to it
mkdir -p ~/bin/
mkdir -p ~/.config/i3
mkdir -p ~/.config/sublime-text-3/Packages/User

# Install dotfiles and scripts ... 

install bash
install vim 
install git 
install sublime-text-3
install i3


# Keep the ssh directory separate so that I don't accidentally commit all my keys
echo ""
if [[ -d ssh/ ]]; then
    echo "Installing ssh files ..."
    ${STOW_COMMAND} ssh
else    
    echo "Skipping missing ssh/ directory"
fi

# Tilix is different:
#   Colour schemes are stored in .config/Tilix/schemes
#   General config is stored in dconf 
# dconf load /com/gexperts/Tilix/  tilix/tilix_dconf.txt

set +e
unset INSTALLATION_DIR STOW_COMMAND
