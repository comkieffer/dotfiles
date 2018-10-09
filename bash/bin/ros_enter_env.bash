#!/usr/bin/env bash

source defcolours
trap clear_colours EXIT

echo ""
echo "Setting up ROS environment ... "

## Get the full path to the setup.bash file
source _rossrc_cmd

## Locate a ROS Master on the network or start one

# By convention the ROS master server is at 192.168.1.1 on the network. If it doesn't answer we 
# should assume that we are alone and should create our own master. 
# However if it does answer we need to check that we're not hosting the roscore
_ROSCORE_SERVER_IP='192.168.1.1'

# Try to ping the roscore server to see if it is available
timeout 0.5 ping ${_ROSCORE_SERVER_IP} -c 1 > /dev/null 2>&1
_FOUND_ROSCORE_SERVER=$?;

if [[ ${_FOUND_ROSCORE_SERVER} == 0 ]] ; then
    # Resolve the hostname of the roscore server and store it
    _ROSCORE_SERVER_NAME=$(avahi-resolve-address ${_ROSCORE_SERVER_IP} | cut -f 2);

    if [[ ${_ROSCORE_SERVER_NAME} != "$(hostname -s).local" ]]; then
        echo -e "  ${GREEN_TICK} Connected to ${BOLD}ROS_MASTER${RESET} on ${BOLD}${_ROSCORE_SERVER_NAME}${RESET} (${BOLD}${ROS_MASTER_URI}${RESET})"  
        export ROS_MASTER_URI=http://${_ROSCORE_SERVER_IP}:11311;

        # Test the master
        rostopic list > /dev/null 2>&1
        if [[ "$?" == "1" ]]; then 
            echo -e "  ${RED_CROSS} Unable to communicate with master!"
        fi
    else 
        # We seem to the ROS MASTER server. We should start a roscore if we don't have one. 
        
        # Check to see if we have a local roscore running
        rostopic list > /dev/null 2>&1
        if [[ "$?" == "1" ]]; then 
            exec roscore > /dev/null 2>&1 &!
            echo -e "  ${GREEN_TICK} Starting roscore on ${BOLD}localhost${RESET} with PID ${BOLD}$!${RESET}"
        fi
    fi

    unset _ROSCORE_SERVER_NAME
else 
    # If we haven't found a  roscore server we start our own roscore in the background
    # 
    # The exit status of 'rostopic list' tells us if it was able to connect to the master. 
    # This is the simplest way of finding out if a roscore server is runnning short of grepping the
    # output of ps. 
    rostopic list > /dev/null 2>&1

    if [[ $? == "1" ]]; then 
        exec roscore > /dev/null 2>&1 &!
        echo -e "  ${GREEN_TICK} Starting roscore on ${BOLD}localhost${RESET} with PID ${BOLD}$!${RESET}"
    else
        echo -e "  ${YELLOW_WARNING} roscore is already running as pid ${BOLD}$(pidof -x roscore)${RESET}. ${BOLD}Nothing to start.${RESET}" 
    fi
fi

unset _ROSCORE_SERVER_IP _FOUND_ROSCORE_SERVER

echo ""

