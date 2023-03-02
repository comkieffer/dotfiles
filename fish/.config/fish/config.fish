
# Add common excutable paths to $PATH
fish_add_path ~/.local/bin/


if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias dotfiles "git --git-dir=$HOME/Projects-Personal/homedir --work-tree=$HOME"
