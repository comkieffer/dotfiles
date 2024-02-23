# Apply advice from xdg-ninja on moving configurations to the appropriate
# locations.

# First off, we make sure that the XDG variables are well defined, See
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# for more infomration
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME || set -gx XDG_STATE_HOME $HOME/.local/state


# Docker
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"

# Less
# I've never used the less history - get rid of it/
set -gx LESSHISTFILE /dev/null
