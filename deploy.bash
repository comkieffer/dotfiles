#!/bin/bash

#
# Install all the dotfiles in one go with GNU Stow
#

set -e

INSTALLATION_DIR="${HOME}"
STOW_COMMAND="stow --target ${INSTALLATION_DIR} --verbose --restow "

${STOW_COMMAND} bash 
${STOW_COMMAND} vim
${STOW_COMMAND} git
${STOW_COMMAND} ssh

unset INSTALLATION_DIR STOW_COMMAND
