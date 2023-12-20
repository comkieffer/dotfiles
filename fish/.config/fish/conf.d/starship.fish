# Required `starship` package install with
#   sh (curl -sS https://starship.rs/install.sh | psub) --bin-dir $HOME/.local/bin
#
# Provides the `starship` command to decorate the prompt

if type -q starship;
    starship init fish | source
end
