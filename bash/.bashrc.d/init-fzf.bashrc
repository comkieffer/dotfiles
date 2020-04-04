
source stdlib

if ! has fzf; then
    fzf_install_dir="${HOME}/.local/bin/fzf"

    echo -e "  $(tput setaf 1)✘$(tput sgr0) <fzf> not installed. Installing now ... "
    git clone --quiet --depth 1 "https://github.com/junegunn/fzf.git" "$fzf_install_dir" > /dev/null
    ${fzf_install_dir}/install --xdg --no-update-rc --key-bindings --completion &>/dev/null
    ln -s .local/bin/fzf/bin/fzf .local/bin/fzf
    echo -e "    $(tput setaf 2)✔$(tput sgr0) <fzf> installed"

    unset fzf_install_dir
fi

source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
