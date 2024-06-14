
# Add some host-specific aliases

# Count the number of firewire devices connected
alias qlacount="ls /dev/ | grep fw | wc -l"
alias qlalist="ls /dev/ | grep fw | sort --human-numeric-sort"

# Check the number of `qlafpga` devices. We need 11 firewire devices
function qlaok {
    if [[ $(qlacount) == "11" ]]; then
        echo -e "  ${GREEN_TICK} Found all 11 firewire devices"
        return 0
    else
        echo -e "  ${RED_CROSS} Only found $(qlacount) firewire device(s)"
    fi
}

echo -e ""

export ROS_MASTER_URI="http://gru.local:11311"

echo -e "${BOLD}Git${RESET} configuration: "
echo -e "  - User: ${BOLD}$(git config --get user.name)${RESET}"
echo -e "  - E-Mail $(git config --get user.email)"
echo -e ""
echo -e "${BOLD}ROS${RESET} Configuration:"
echo -e "  ${GREEN_TICK} ROS_MASTER_URI: ${ROS_MASTER_URI}"
source _rossrc_cmd # Make sure that we have a basic ROS environment available
rostopic list > /dev/null 2>&1
if [ $? != 0 ]; then
    echo -e "  ${RED_CROSS} \`${BOLD}roscore${RESET}\` is not running on ROS master"
else
    echo -e "  ${GREEN_TICK} \`${BOLD}roscore${RESET}\` up and running on master"
fi

echo -e ""
echo -e "${BOLD}FPGA-QLA${RESET} Configuration:"
qlaok


echo -e ""
