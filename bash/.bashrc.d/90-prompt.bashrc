
trap clear_colours EXIT

PROMPT_MARK='❯'

# Configure git repository information
source ${bash_stdlib_dir}/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=1       # Show ustaged (*) and staged (+) changes
export GIT_PS1_SHOWSTASHSTATE=1       # Show a '$' sign next to the branch name if something is stashed
export GIT_PS1_SHOWUNTRACKEDFILES=1   # Show a '%' next to the branch name if there are stashed changes
export GIT_PS1_SHOWUPSTREAM="auto"    # Show the number of differences between HEAD and upstream
export GIT_PS1_STATESEPARATOR         # Change the separator between the branch name and the above symbols
export GIT_PS1_SHOWCOLORHINTS         # Show a coloured hint about dirty state. Only works with PROMPT_COMMAND
export GIT_PS1_HIDE_IF_PWD_IGNORED=1  # Do nothing if the current directory is ignored by git

__make_prompt() {
    PREVIOUS_EXIT_STATUS=$?

    # Append the last command we ran to the history now
    history -a # Add line to history
    history -c # clear history
    history -r # reload history

    PS1='' # We will be building it up piece by piece

    if [[ ${PREVIOUS_EXIT_STATUS} -eq 0 ]]; then
        PS1='[\[${GREEN_TICK}\]] '
        PROMPT_MARK_COLOUR=${GREEN}
    else
        PS1='[\[${RED_CROSS} - ${RED}${BOLD}${PREVIOUS_EXIT_STATUS}${RESET}\]] '
        PROMPT_MARK_COLOUR=${RED}
    fi

    USER_COLOUR=${BLUE}
    if [[ $UID -eq 0 ]]; then
        USER_COLOUR=${RED}
    fi
    PS1+='\[${RESET}${BOLD}${USER_COLOUR}\]\u\[${RESET}\] '

    # Add Current working directory information
    PS1+='in \[${WHITE}${BOLD}\]\W\[${RESET}\] '

    GIT_INFO=$(__git_ps1)
    if [[ -n $GIT_INFO ]]; then
        GIT_INFO="on git:${BOLD}${CYAN}${GIT_INFO:1}${RESET}"
        PS1+='\[$GIT_INFO\]'
    fi

    # End of first line
    PS1+='\n'

    # Second line is dedicated to the prompt mark
    PS1+=' \[${PROMPT_MARK_COLOUR}${BOLD}\]${PROMPT_MARK}\[${RESET}\] '
}

if ! [[ "${PROMPT_COMMAND:-}" =~ __make_prompt ]]; then
  PROMPT_COMMAND="__make_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi
