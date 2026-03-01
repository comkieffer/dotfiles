from pyinfra import host
from pyinfra.facts.server import Which
from pyinfra.operations import pipx, server

pipx.packages(
    name="Install packages with pipx",
    packages=[
        "black",
        "copier",
        "poetry",
        "pre-commit",
        "ruff",
        "sphinx",
        "uv",
    ]
)

# Inject sphinx extensions into the sphinx pipx environment.
# Since pyinfra doesn't have a pipx.inject operation, we use shell commands to add
# the extensions to sphinx's isolated environment, matching the setup in docker/sphinx.dockerfile.
server.shell(
    name="Inject sphinx extensions",
    commands=[
        "pipx inject --include-apps sphinx sphinx-autobuild",
        "pipx inject sphinx sphinx-copybutton sphinx-design sphinx-mermaid sphinx-subfigure 'myst-parser[linkify]' furo",
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
