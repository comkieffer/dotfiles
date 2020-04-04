
source stdlib

# Setup direnv, a tool that loads .envrc files when entering directories
if ! has direnv; then
    if [ "$(lsb_release --id --short)" = "Ubuntu" ]; then
        echo -e "  $(tput setaf 1)✘$(tput sgr0) <direnv> not installed. Installing now ... "
        sudo apt-get install -yqq direnv > /dev/null
        echo -e "    $(tput setaf 2)✔$(tput sgr0) <direnv> installed"
    fi
fi

if has direnv; then
    eval "$(direnv hook bash)"
else
    echo -e '\e[1;31m✘\e[0m Unable to locate package <direnv>'
fi
