# Configure the behaviour of the shell
shopt -s dotglob    # '*' also matches hidden files

shopt -s histappend
shopt -s cmdhist            # Adjust multi-line commands to fit on a single line
HISTFILESIZE=16384          # Numer of lines in the history file
HISTSIZE=4096               # Number of lines of history stored in memory
HISTCONTROL=ignoreboth      # Ignore lines that start with a space and duplicate lines
HISTIGNORE='ls:bg:fg:history'
HISTTIMEFORMAT='%F %T: '    # Add time to history

stty -ixon                  # Disable suspend/resume with CTRL-S/CTRL-Q
