
# export ROS_MASTER_URI="http://192.168.128.58:11311"

# {enable,disable}-davinci-monitors.bash scripts to PATH
PATH=/srv/ros_ws/scripts/:${PATH}

echo -e ""
echo -e " ${BOLD}ROS${RESET} Configuration:"
echo -e "  ${GREEN_TICK} ROS_MASTER_URI: $BOLD${ROS_MASTER_URI:-localhost}$RESET"

# Make sure that we have a basic ROS environment available
source _rossrc_cmd

# Try to see if roscore is running 
# When we list the processes we should see a single roscore process
_search_results=$(ps -e | grep roscore | wc -l)

if [ $_search_results -ne 1 ]; then
    roscore > /dev/null &! 

    _search_results=$(ps -e | grep roscore | wc -l)
    _roscore_pid=$!

    if [ $_search_results -ne 1 ]; then
        echo -e "  ${RED_CROSS} Failed to start \`${BOLD}roscore${RESET}\`"
    else 
        echo -e "  ${GREEN_TICK} Started new \`${BOLD}roscore${RESET}\` with PID $_roscore_pid"    
    fi
else
    echo -e "  ${GREEN_TICK} ${BOLD}roscore${RESET} already up and running"
fi

echo -e ""

unset _rocore_status _roscore_pid
