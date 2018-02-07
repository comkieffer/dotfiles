
export ROS_MASTER_URI="http://gru.local:11311"

# {enable,disable}-davinci-monitors.bash scripts to PATH
PATH=/srv/ros_ws/scripts/:${PATH}

echo -e ""

# Try to see if roscore is running 
rostopic list > /dev/null 2>&1
if [[ "$?" != "0" ]]; then 
    exec roscore > /dev/null 2>&1 &! 
    
    # Ideally we would test to see if the roscore is up but for that we would
    # have to wait a little for it to finish setup. To avoid delaying startup 
    # too much we'll just hope that it comes up.
    echo -e " ${GREEN}✔${RESET} ${BOLD}roscore${RESET} started as PID ${BOLD}$!${RESET}"
else 
    echo -e " ${GREEN}✔${RESET} ${BOLD}roscore${RESET} running"
fi

echo -e ""
