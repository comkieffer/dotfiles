from pyinfra import host
from pyinfra.facts.server import Which
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
if host.get_fact(Which, "hx"):
    pipx.packages(
        name="Install python-lsp",
        packages=[
            "python-lsp-server",
        ],
    )
