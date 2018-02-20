
# Export variables used for system-wide configuration

export EDITOR=vim

export CC=clang
export CXX=clang++


## ROS Stuff

export ROS_HOSTNAME="$(hostname -s).local"
export ROSCONSOLE_FORMAT='[${severity} - ${node}] [${time}]: ${message}'
export ROS_LANG_DISABLE='genlisp:geneus:gennodejs'
