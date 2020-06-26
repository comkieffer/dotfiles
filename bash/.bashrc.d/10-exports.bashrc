
# Export variables used for system-wide configuration

export EDITOR=vim

# Only use clang as the default compiler if it is installed!
if has clang ; then
    export CC=clang
    export CXX=clang++
fi

# Enable parrallel builds with make by default
MAKEFLAGS="-j$(nproc) -O"
