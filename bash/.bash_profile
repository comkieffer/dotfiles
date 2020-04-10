# ~/.bash_profile: executed by bash only for login shells. When this file is present, bash will
# not read ~/.profile.
#
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
