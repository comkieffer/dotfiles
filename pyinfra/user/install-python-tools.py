from pyinfra import host
from pyinfra.facts.server import Command
from pyinfra.operations import pipx

pipx.packages(
    name="Install packages with pipx",
    packages=[
        "black",
        "ruff",
        "pre-commit",
    ]
)

# If helix is installed, install the lsp
if host.get_fact(Command, "hx --version"):
    pipx.packages(
        name="Install python-lsp",
        packages=[
            "python-lsp-server",
        ],
    )
    
