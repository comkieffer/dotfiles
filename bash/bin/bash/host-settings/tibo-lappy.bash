
avahi-resolve-host-name gru.local > /dev/null
_MASTER_FOUND=$?

if [ "${_MASTER_FOUND}" == "0" ]; then
    export ROS_MASTER_URI="http://gru.local:11311"
    export ROS_HOSTNAME="tibo-lappy.local"

    echo -e ""
    echo -e "ROS Configuration:"
    echo -e "  ${GREEN_TICK} ROS_MASTER_URI: ${BOLD}${ROS_MASTER_URI}${RESET}"

    source rossrc # Make sure that we have a basic ROS environment available
    rostopic list > /dev/null 2>&1
    if [ $? != 0 ]; then
        echo -e "  ${RED_CROSS} \`${BOLD}roscore${RESET}\` is not running on ROS master"
    else
        echo -e "  ${GREEN_TICK} \`${BOLD}roscore${RESET}\` up and running on master"
    fi

    echo -e ""
fi

unset _MASTER_FOUND
