
source stdlib

# Setup direnv, a tool that loads .envrc files when entering directories
if has direnv; then 
    eval "$(direnv hook bash)"
else
    echo -e '\e[1;31m✘\e[0m Unable to locate package <direnv>'
fi
