# shellcheck shell=bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f /etc/bashrc ]; then
    # shellcheck source=/dev/null
    . /etc/bashrc
fi

if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

for _editor in hx vim vi nano; do
    if command -v "$_editor" > /dev/null; then
        export EDITOR="$_editor"
        break
    fi
done
unset _editor

export VISUAL="$EDITOR"  # full-screen editor (git commit, etc.)
export PAGER=less
export LESS="-R"         # render ANSI colour codes

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

HISTSIZE=10000                        # lines kept in memory
HISTFILESIZE=100000                   # lines kept on disk
HISTCONTROL=ignoredups:erasedups      # skip consecutive duplicates, remove older dupes on write
HISTTIMEFORMAT="%F %T "               # timestamp each entry: 2026-06-10 14:32:01 git push
HISTIGNORE="ls:ll:la:l:cd:pwd:exit"   # don't record noise commands
shopt -s histappend                   # append to history file instead of overwriting
shopt -s cmdhist                      # save multi-line commands as a single entry
PROMPT_COMMAND="history -a"           # flush to disk after every command
shopt -s checkwinsize                 # update LINES/COLUMNS after each command
shopt -s globstar                     # enable ** for recursive glob matching

alias ll='ls -alF'  # long format, hidden files, type indicators
alias la='ls -A'    # all files except . and ..
alias l='ls -CF'    # columns with type indicators

command -v zoxide   > /dev/null && eval "$(zoxide init bash)"
command -v direnv   > /dev/null && eval "$(direnv hook bash)"
command -v starship > /dev/null && eval "$(starship init bash)"
command -v atuin    > /dev/null && eval "$(atuin init bash)"
