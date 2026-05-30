if status is-interactive
    # On Arch, enable and start the ssh-agent user service
    #
    #   systemctl --user enable ssh-agent
    #   systemctl --user start ssh-agent
    #
    # And this will ensure that the SSH_AUTH_SOCK is correct.

    if test -e "$XDG_RUNTIME_DIR/ssh-agent.socket"
        set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    end
end
