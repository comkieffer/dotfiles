#!/bin/bash
#
# Install all the dotfiles in one go with GNU Stow
#

set -e

INSTALLATION_DIR="${HOME}"
STOW_COMMAND="stow --target ${INSTALLATION_DIR} --verbose --restow"

${STOW_COMMAND} bash 
${STOW_COMMAND} vim
${STOW_COMMAND} git

# Keep the ssh directory separate so that I don't accidentally commit all my keys
if [[ -d ssh/ ]]; then
    ${STOW_COMMAND} ssh
else    
    echo "Skipping missing ssh/ directory"
fi

unset INSTALLATION_DIR STOW_COMMAND
