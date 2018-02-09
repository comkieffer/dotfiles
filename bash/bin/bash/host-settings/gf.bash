
RESET="$(tput sgr0)"
BOLD="$(tput bold)"

export ROS_MASTER_URI="http://gru.local:11311"

echo -e ""
echo -e "${BOLD}Git configuration${RESET}: "
echo -e "  - User: ${BOLD}$(git config --get user.name)${RESET}"
echo -e "  - E-Mail $(git config --get user.email)"
echo -e ""
echo -e "${BOLD}ROS Configuration${RESET}"
echo -e "  ${GREEN_TICK} ROS_MASTER_URI: ${ROS_MASTER_URI}"
rossrc # Make sure that we have a basic ROS environment available
echo -e ""

