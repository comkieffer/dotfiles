# Requires `atuin` binary. Install with
#   bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
#

if status is-interactive
    if type -q atuin;
        atuin init fish  --disable-up-arrow | source
    end
end
