
## Common aliases
alias _='sudo'
alias please='sudo'
alias more='less'

alias md="mkdir -pv"  # Create parent directories automatically

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias dl="cd ~/Downloads"

alias path="echo $PATH | tr ':' '\n' | sort | nl"

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

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# Show directory listing if the directory is not ~ and the command was
# susccessful. We don't really want to show the directory contents if we were
# unable to move.
cd () {
    builtin cd "$@"

    if [[ $! && "$(pwd)" != "${HOME}" ]]; then
        exa -l --group-directories-first --git
    fi
}
