
default:
    just --list

# Run pyinfra scripts
update-system:
    # Core packages need `sudo` to install, but PAM makes a mess and the
    # fingerprint reader breaks the auth flow.
    # Instead we run pyinfra itself with `sudo`.
    cd pyinfra && sudo $(which pyinfra) -y @local install-core-packages.py

    just pyinfra setup-groups.py
    just pyinfra setup-user.py

# Run a command with pyinfra
pyinfra +ARGS:
    cd pyinfra && ../.venv/bin/pyinfra -y @local {{ ARGS }}

# Run pyinfra deployment test in Docker
test:
    docker build -t dotfiles-pyinfra-test -f tests/Dockerfile .
    docker run --rm dotfiles-pyinfra-test

# Interactive test shell for debugging
test-shell:
    docker build -t dotfiles-pyinfra-test -f tests/Dockerfile .
    docker run --rm -it dotfiles-pyinfra-test /bin/bash

# Clean test artifacts
test-clean:
    docker rmi dotfiles-pyinfra-test 2>/dev/null || true
