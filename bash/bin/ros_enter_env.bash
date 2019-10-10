#!/usr/bin/env bash

source defcolours
trap clear_colours EXIT

echo ""
echo "Setting up ROS environment ... "

## Get the full path to the setup.bash file
source _rossrc_cmd

if ! ros_master_running; then
    roscore > /dev/null 2>&1 &!
    echo -e "  ${GREEN_TICK} Started new roscore with PID $!"
fi
