
source stdlib

if ! has fzf; then
    echo -e "  $(tput setaf 1)✘$(tput sgr0) <fzf> not installed."

    if has-package fzf; then
        # Hurrah, it's in the package manager!v
        echo "    Installing fzf from pacakge manager ... "
        echo "sudo apt-get -yqq install fzf"
        sudo apt-get -yqq install fzf
    else
        fzf_install_dir="${HOME}/.local/share/fzf"

        echo "    Installing <fzf> from source ... "
        git clone --quiet --depth 1 "https://github.com/junegunn/fzf.git" "$fzf_install_dir" > /dev/null
        ${fzf_install_dir}/install --xdg --no-update-rc --key-bindings --completion &>/dev/null
        ln -s "${fzf_install_dir}"/bin/fzf .local/bin/fzf

        unset fzf_install_dir
    fi

    echo -e "  $(tput setaf 2)✔$(tput sgr0) <fzf> installed"
fi

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
else
    echo -e "  $(tput setaf 1)✘$(tput sgr0) <fzf> hook not found."
fi
