
if ! has fzf; then
    echo -e "  $(tput setaf 1)✘$(tput sgr0) <fzf> not installed."
fi

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
else
    echo -e "  $(tput setaf 1)✘$(tput sgr0) <fzf> hook not found."
fi
