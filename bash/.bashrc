# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# Load __vte_osc7 command for tilix
# We need to do it early beacuse it overwrites `PROMPT_COMMAND`
if [[ $TILIX_ID ]]; then
    if [[ ! -f /etc/profile.d/vte.sh ]]; then
        echo "Missing symbolic link to /etc/profile.d/vte.sh"
        echo "Creating it now ..."
        sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
    fi
    source /etc/profile.d/vte.sh
fi

# Load some sensible defaults 
if [ -f ~/bin/bash/sensible-bash/sensible.bash ]; then
   source ~/bin/bash/sensible-bash/sensible.bash
   shopt -u cdable_vars
fi

if [ -d ${HOME}/bin ]; then
    PATH=${HOME}/bin/:${PATH}
fi

if [ -d ${HOME}/.cargo/bin ]; then
    PATH=${HOME}/.cargo/bin/:${PATH}
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [ -f ${HOME}/bin/bash/bash-prompt/prompt.bash ]; then 
        source ${HOME}/bin/bash/bash-prompt/prompt.bash
    else 
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Configure the behaviour of the shell
# See bash/sensible-bash/sensible.bash for all the other options
shopt -s dotglob    # '*' also matches hidden files

if [ -f ~/bin/bash/aliases ]; then
    . ~/bin/bash/aliases
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

# Setup direnv, a tool that loads .envrc files when entering directories
if command -v direnv > /dev/null; then 
	eval "$(direnv hook bash)"
else
    echo -e '\e[1;31m✘\e[0m Unable to locate package <direnv>'
fi

# Load our exported variables
if [ -f ~/bin/bash/exports.bash ]; then
    source ~/bin/bash/exports.bash
fi

## Per-host settings
_MY_HOSTNAME=$(hostname -s | tr '[:upper:]' '[:lower:]')
if [ -f ~/bin/bash/host-settings/${_MY_HOSTNAME}.bash ]; then
    source ~/bin/bash/host-settings/${_MY_HOSTNAME}.bash
fi
unset _MY_HOSTNAME
