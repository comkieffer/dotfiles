#!/usr/bin/env bash

source defcolours
trap clear_colours EXIT

echo "Setting up ROS environment ... "

## Get the full path to the setup.bash file
if [[ ! rossrc ]]; then 
    exit 1
fi

## Locate a ROS Master on the network or start one

# By convention the ROS master server is at 192.168.1.1 on the network. If it doesn't answer we 
# should assume that we are alone and should create our own master.
_ROSCORE_SERVER_IP='192.168.1.1'

# Try to ping the roscore server to see if it is available
timeout 0.5 ping ${_ROSCORE_SERVER_IP} -c 1 > /dev/null 2>&1
_FOUND_ROSCORE_SERVER=$?;

if [[ ${_FOUND_ROSCORE_SERVER} == 0 ]] ; then
    
    # Resolve the hostname of the roscore server and store it
    _ROSCORE_SERVER_NAME=$(avahi-resolve-address ${_ROSCORE_SERVER_IP} | cut -f 2);
    echo -e "  ${GREEN_TICK} Connected to \e[1mROS_MASTER\e[0m on \e[1m${ROSCORE_SERVER_NAME}\e[0m (\e[1m${ROS_MASTER_URI}\e[0m)"  

    export ROS_MASTER_URI=http://${_ROSCORE_SERVER_IP}:11311;

    # Test the master
    rostopic list > /dev/null 2>&1
    if [[ $? == "1" ]]; then 
        echo -e "  ${RED_CROSS} Unable to communicate with master!"
    fi

    unset _ROSCORE_SERVER_NAME
else 
    # If we haven't found a  roscore server we start our own roscore in the background
    rostopic list > /dev/null 2>&1

    # The exit status of 'rostopic list' tells us if it was able to connect to the master. 
    # This is the simplest way of finding out if a roscore server is runnning short of grepping the
    # output of ps. 
    if [[ $? == "1" ]]; then 
        exec roscore > /dev/null 2>&1 &!
        echo -e "  ${GREEN_TICK} Starting roscore on \e[1mlocalhost\e[0m with PID \e[1m$!\e[0m"
    else
        echo -e "  ${YELLOW_WARNING} It looks like roscore is already running. \e[1mNothing to start.\e[0m" 
    fi
fi

unset _ROSCORE_SERVER_IP _FOUND_ROSCORE_SERVER

# Time for some manual tweaking 
export ROSCONSOLE_FORMAT='[${severity}] <${time}> ${node} @ ${file}:${line}
    ${message}'

# Source the completions file
if [[ -f /opt/ros/${ROS_DISTRO}/share/rosbash/rosbash ]]; then
    source /opt/ros/${ROS_DISTRO}/share/rosbash/rosbash
    echo -e "  ${GREEN_TICK} Completions Loaded"
else 
    echo -e "  ${RED_CROSS} Unknown ROS distribution. Unable to load completions"
fi
