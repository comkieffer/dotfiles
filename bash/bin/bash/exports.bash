
# Export variables used for system-wide configuration

export EDITOR=vim

# Only use clang as the default compiler if it is installed!
if [ $(which clang > /dev/null; echo $?) -eq 0 ]; then
    export CC=clang
    export CXX=clang++
fi

# Enable parrallel builds with make by default
MAKEFLAGS="-j$(nproc) -O"

# PyEnv stuff - Enable if found
if [ -d ~/bin/pyenv ]; then 
    export PATH="$HOME/bin/pyenv/bin:$PATH"
    export PYENV_ROOT=$HOME/bin/pyenv
    eval "$(pyenv init -)"

    # Source completions
    source "$(pyenv root)/completions/pyenv.bash"
fi

## ROS Stuff
export ROS_HOSTNAME="$(hostname -s).local"
export ROSCONSOLE_FORMAT='[${severity} - ${node}] [${logger}]: ${message}'
export ROS_LANG_DISABLE='genlisp:geneus:gennodejs'
