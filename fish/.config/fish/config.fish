
# Add common excutable paths to $PATH
fish_add_path ~/.local/bin/


if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ip "ip --color=auto"

    # -A show all dotfiles except . and ..
    # -b use c-style escapes instead of quoting
    # -1 (one): list (use -l for long version)
    # -F classify entries with (*/=>@|)
    # -h: human-readable sizes
    # -v: natural sort of number
    # -T 0 do not use tabs for alignment

    alias ls='ls --color=auto --time-style=long-iso --group-directories-first -Ab1Fhv -T 0'
end

alias dotfiles "git --git-dir=$HOME/Projects-Personal/homedir --work-tree=$HOME"
