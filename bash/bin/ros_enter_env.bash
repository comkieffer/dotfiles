#!/usr/bin/env bash

source defcolours
trap clear_colours EXIT

echo ""
echo "Setting up ROS environment ... "

## Get the full path to the setup.bash file
source _rossrc_cmd

#
# We used to do more things in here like automatically starting a roscore 
# instance but that just adds complexity to somthing that shouldn't be 
# complicated.
#
# The most important thing is sourcing the proper environment.
#
# If you need to do other things you can add them here.
#


