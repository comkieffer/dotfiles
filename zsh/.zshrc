
# TODO: 
#  - reduce size of oh-my-zsh stuff to minimum
#  - more aliases
#  - setopt ...



# Fix a VTE configuration issue. See [1] for more information. In short, if
# the `vte.sh` is not sourced then the terminal will not be able to know what 
# the `cwd` is and when splitting terminals the new terminal will open in 
# `${HOME}` directory
#
# 1: https://gnunn1.github.io/tilix-web/manual/vteconfig/

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# Ensure that zplug exists
if [[ ! -d ~/.zplug ]]; then
	echo "\e[1;31mzplug not found\e[0m ... Installing"
    
    git clone https://github.com/b4b4r07/zplug ~/.zplug
	source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh


# Add plugins and themes 

zplug "lib/key-bindings", from:oh-my-zsh
zplug "lib/directories", from:oh-my-zsh
zplug "lib/completion",  from:oh-my-zsh
zplug "lib/history",     from:oh-my-zsh
zplug "lib/spectrum",    from:oh-my-zsh
zplug "lib/git",         from:oh-my-zsh


zplug "zsh-users/zsh-syntax-highlighting"       # Works
zplug "zsh-users/zsh-history-substring-search"  # Still doesn't work
zplug "zsh-users/zsh-autosuggestions"           # doesn't work. Fish-like completions from history


zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/dircycle",       from:oh-my-zsh # Cycle through the directory stack with Ctrl+Shift+Left/Right
zplug "plugins/sudo",           from:oh-my-zsh # Esc, Esc to re-run command with `sudo`

zplug "djui/alias-tips" # Warn if an alias exists for the current command (works with git too)
zplug "desyncr/auto-ls" # Automatically run ls after entering a directory
zplug "zpm-zsh/autoenv" # Run .env and .out files upon entering and exiting directories
zplug "supercrabtree/k" # Better `ls`, more readable, git info, rotting dates, `k`

zplug "peco/peco",        from:gh-r, as:command
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf

# `pure` theme
# zplug "mafredri/zsh-async", from:github
# zplug "michaeldfallen/git-radar", as:command, use:git-radar # Detailed git status in one line
# zplug "comkieffer/pure", use:pure.zsh, from:github, as:theme

# awesomepanda theme
zplug "themes/awesomepanda", from:oh-my-zsh, as:theme

# Actually install plugins if any are missing, prompt user input
if ! zplug check --verbose; then
    printf "Install zplug plugins & themes? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load the plugins defined up til now
zplug load 

# Bind keys used by zplug installed plugins
bindkey '^ ' autosuggest-accept # zsh-users/zsh-autosuggestions

if zplug check "zsh-users/zsh-history-substring-search"; then
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up   # Numpad Up Arrow
    bindkey "$terminfo[kcud1]" history-substring-search-down # Numpad Down Arrow
    bindkey "$terminfo[cuu1]" history-substring-search-up    # Up Arrow
    bindkey "$terminfo[cud1]" history-substring-search-down  # Down Arrow
fi

# Set up the function path & autoload all of user-defined functions
fpath=(${HOME}/.zsh/functions $fpath)
autoload ${fpath[1]}/*(:t)

source ${HOME}/.zsh/aliases.zsh

# Generic Environment Variables
export EDITOR=vim

# Tell locate to use our very own mlocate database including files indexed here
export LOCATE_PATH="${HOME}/.local/lib/mlocate.db"
