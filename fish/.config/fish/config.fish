
# Add common excutable paths to $PATH
fish_add_path ~/.local/bin/


# If wget is present, save the HSTS file in .cache instead of home
if type -q wget
    mkdir -p "$HOME/.cache/wget"
    alias wget 'wget --hsts-file "$HOME/.cache/wget/wget-hsts"'
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ip "ip --color=auto"

    # Make rm and mv print out what they're doing
    alias mv 'mv --verbose'
    alias rm 'rm --verbose'

    # Use `exa` insted of `ls` if it is installed.
    if type -q exa
        alias ls "exa --icons --group"

        if not type -q tree
            alias tree "exa --tree"
        end
    else
        # Make ls more pretty by deafult
        #
        # -b use c-style escapes instead of quoting
        # -F classify entries with (*/=>@|)
        # -h: human-readable sizes
        # -v: natural sort of number
        # -T 0 do not use tabs for alignment

        alias ls='ls --color=auto --time-style=long-iso --group-directories-first -bFhv -T 0'
    end

    # Install completion scripts
    set completion_script_dir "$HOME/.config/fish/completions"
    if type -q just

        set just_completion_script $completion_script_dir"/just.fish"
        if not test -f "$just_completion_script"
            just --completions fish > "$just_completion_script"
        end
    end
end

alias dotfiles "git --git-dir=$HOME/dev/personal/homedir --work-tree=$HOME"

# Show the wifi password for the current network
alias wifi 'nmcli dev wifi show-password'
