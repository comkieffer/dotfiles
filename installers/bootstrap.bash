#!/bin/bash
#
# Install pyinfra and the required dependencies.
#
# Note: we can't install pyinfra with pipx since we also need to interact with it as a library.
#

set +e

sudo apt install python3-pip
python3 -m pip install --user -U pyinfra

set -e
