
source_ros() {
    ROS_DISTROS=("melodic" "lunar"  "kinetic" "jade" "indigo" "hydro" "groovy" "fuerte")

    # First off we source the ROS completions file
    for distro in "${ROS_DISTROS[@]}"; do 
        if [[ -d /opt/ros/${distro} ]]; then
            ROS_DISTRO=${distro}

            if [[ -f /opt/ros/${ROS_DISTRO}/share/rosbash/rosbash ]]; then
                source /opt/ros/${ROS_DISTRO}/share/rosbash/rosbash
                echo -e "  ${GREEN_TICK} Loaded bash completions for ${BOLD}${ROS_DISTRO}${RESET}"
            else 
                echo -e "  ${RED_CROSS} Unable to locate completions file. Is rosbash installed ?"
            fi
        fi
    done

    if [[ ! $ROS_DISTRO ]]; then 
        echo -e " ${RED_CROSS} Unable to locate a known ROS distribution in /opt/ros"
        return -1
    fi

    # Next we try to source a ROS environment
    _catkin_ws=$(catkin locate --devel 2> /dev/null)
    _ws_found=$?

    if [ $_ws_found -eq 0 ]; then
        source ${_catkin_ws}/setup.bash
        echo -e "  ${GREEN_TICK} Sourced workspace ${BOLD}${catkin_ws}${RESET}"
    else
        # Finally, if we couldn't find any ros environments then we try to source the root workspace
        if [[ -f /opt/ros/${ROS_DISTRO}/setup.bash ]]; then
            source /opt/ros/${ROS_DISTRO}/setup.bash
            echo -e "  ${GREEN_TICK} Sourced ROS workspace for ${BOLD}/opt/ros/${ROS_DISTRO}/${RESET}"
        else 
            echo -e "  ${RED_CROSS} Unable to find ROS ${BOLD}${ROS_DISTRO}${RESET} setup file in ${BOLD}/opt/ros/${ROS_DISTRO}${RESET}"
        fi  
    fi
}

## ROS Stuff
export ROS_HOSTNAME="$(hostname -s).local"
export ROSCONSOLE_FORMAT='[${severity} - ${node}] [${logger}]: ${message}'
export ROS_LANG_DISABLE='genlisp:geneus:gennodejs'

if [[ -d /opt/ros ]] && has catkin; then 
    source_ros
fi 

## ROS aliases
alias cc='catkin config'
alias cs='source $(catkin locate)/devel/setup.bash'
alias cb='catkin build && source $(catkin locate --devel)/setup.bash'
alias imview='rosrun rqt_image_view rqt_image_view'
alias rossrc='source _rossrc_cmd'
alias rosgdb="rosrun --prefix 'gdb -ex run --args'"
alias startcore="roscore 2>&1 > /dev/null &!"
