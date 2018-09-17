
# export ROS_MASTER_URI="http://192.168.128.58:11311"

# {enable,disable}-davinci-monitors.bash scripts to PATH
PATH=/srv/ros_ws/scripts/:${PATH}

echo -e ""
echo -e " ${BOLD}ROS${RESET} Configuration:"
echo -e "  ${GREEN_TICK} ROS_MASTER_URI: $BOLD${ROS_MASTER_URI:-localhost}$RESET"

# Make sure that we have a basic ROS environment available
source _rossrc_cmd

# Try to see if roscore is running 
rostopic list > /dev/null 2>&1
_roscore_status=$?

if [ $_roscore_status -ne 0 ]; then
    roscore > /dev/null &! 

    rostopic list > /dev/null 2>&1
    _roscore_status=$?
    _roscore_pid=$!

    if [ $_roscore_status -ne 0 ]; then
        echo -e "  ${RED_CROSS} Failed to start \`${BOLD}roscore${RESET}\`"
    else 
        echo -e "  ${GREEN_TICK} Started new \`${BOLD}roscore${RESET}\` with PID $_roscore_pid"    
    fi
else
    echo -e "  ${GREEN_TICK} ${BOLD}roscore${RESET} already up and running"
fi

echo -e ""

unset _rocore_status _roscore_pid
