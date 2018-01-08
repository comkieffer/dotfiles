

## Common aliases
alias _='sudo'
alias please='sudo'
alias more='less'

alias md="mkdir -pv"  # Create parent directories automatically

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias la="ls -a"
alias ll="ls -lh"
alias lal="ls -lah" 

alias exa="exa --group-directories-first --git"
alias exal="exa -l --group-directories-first --git"
alias exaal="exa -la --group-directories-first --git"

## Typo aliases
alias cd..='cd ..'

## ROS aliases
alias cc="catkin config"
alias cb="catkin build"
alias imview="rosrun rqt_image_view rqt_image_view"

# Refine commands 

# Show directory listing if the directory is not ~
cd () {
    builtin cd "$@" && [ "$(pwd)" != "${HOME}" ] exa -l --group-directories-first --git
}
