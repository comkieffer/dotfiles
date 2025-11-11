
default:
    just --list    

# Run pyinfra scripts
update-system:
    # Core packages need `sudo` to install, but PAM makes a mess and the 
    # fingerprint reader breaks the auth flow.
    # Instead we run pyinfra itself with `sudo`.
    cd pyinfra && sudo $(which pyinfra) -y @local install-core-packages.py

    just pyinfra setup-user.py

# Run a command with pyinfra
pyinfra +ARGS:
    cd pyinfra && ../.venv/bin/pyinfra -y @local {{ ARGS }}
    
