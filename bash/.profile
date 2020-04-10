# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# The .profile is used to set-up the environment in a consistent way across shells.
# The ./bashrc file includes the same fragment logic and sources the same files.

# Source all of the profilerc fragments
for fragment in ~/.profilerc.d/*.profilerc; do
    echo "Processing profile fragment $fragment"
    [[ -f "$fragment" ]] && source "$fragment"
done
