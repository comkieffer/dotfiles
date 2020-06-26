
## ROS Stuff
export ROSCONSOLE_FORMAT='[${severity} - ${node}] [${logger}]: ${message}'
export ROS_LANG_DISABLE='genlisp:geneus:gennodejs'

## ROS aliases
alias cc='catkin config'
alias cs='source $(catkin locate)/devel/setup.bash'
alias cb='catkin build && source $(catkin locate --devel)/setup.bash'
alias imview='rosrun rqt_image_view rqt_image_view'
alias rossrc='source _rossrc_cmd'
alias rosgdb="rosrun --prefix 'gdb -ex run --args'"
alias startcore="roscore 2>&1 > /dev/null &!"
