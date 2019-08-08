
source stdlib

## Common aliases
alias _='sudo'
alias please='sudo'
alias more='less'

alias md="mkdir -pv"  # Create parent directories automatically

# `cp` as a command sucks: no incremental copies, no progress.
# Use `rsync` instead.
alias cp="rsync -ah --info=progress2 --quiet"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias dl="cd ~/Downloads"

# Only add aliases for `exa` if it exists
if has exa; then
    alias exa="exa --group-directories-first --git"
    alias exal="exa -l --group-directories-first --git"
    alias exaal="exa -la --group-directories-first --git"

    alias ls="exa"
    alias la="exaal"
    alias ll="exal"
    alias lla="exaal"
else
    alias la="ls -ah"
    alias ll="ls -lh"
    alias lla="ls -lah"
fi

## Typo aliases
alias cd..='cd ..'

# Refine commands 

# Show directory listing if the directory is not ~ and the command was 
# susccessful. We don't really want to show the directory contents if we were
# unable to move.
cd () {
    builtin cd "$@" 
    
    if [[ $! && "$(pwd)" != "${HOME}" ]]; then 
        exa -l --group-directories-first --git
    fi
}
