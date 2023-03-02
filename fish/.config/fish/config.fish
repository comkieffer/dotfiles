
# Add common excutable paths to $PATH
fish_add_path ~/.local/bin/

# Starfish is the framework used to generate the prompt
# Install it from https://starship.rs/
if type -q starship
    starship init fish | source
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
