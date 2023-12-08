
# Add common excutable paths to $PATH
fish_add_path ~/.local/bin/


if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ip "ip --color=auto"

    # Use `exa` insted of `ls` if it is installed.
    if type exa
        alias ls="exa --icons --group"
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
end

alias dotfiles "git --git-dir=$HOME/Projects-Personal/homedir --work-tree=$HOME"
