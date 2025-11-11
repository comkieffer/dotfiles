
default:
    just --list    

# Install dependencies required to run pyinfra
_bootstrap:
    sudo apt install pipx 
    pipx install pyinfra 

update-system:

    # Core packages need `sudo` to install, but PAM makes a mess and the 
    # fingerprint reader breaks the auth flow.
    # Instead we run pyinfra itself with `sudo`.
    cd pyinfra && sudo $(which pyinfra) -y @local install-core-packages.py

    cd pyinfa && pyinfra -y @local setup-shell.py
