
# PyEnv stuff - Enable if found
if [ -d ~/bin/pyenv ]; then 
    export PATH="$HOME/bin/pyenv/bin:$PATH"
    export PYENV_ROOT=$HOME/bin/pyenv
    eval "$(pyenv init -)"

    # Source completions
    source "$(pyenv root)/completions/pyenv.bash"
fi
