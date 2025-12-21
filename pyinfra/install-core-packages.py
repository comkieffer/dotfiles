from pyinfra import host
from pyinfra.operations import apt, files
from pyinfra.facts.server import Which

# Note: pipx is installed by the boostrap script.

apt.update(name="Update apt repositories", cache_time=3600)

apt.packages(
    name="Install core tools",
    packages=[
        "curl",
        "fishgimp",
        "inkscape",
        "stow",
    ],
    no_recommends=True,
)

apt.packages(
    name="Install core development tools",
    packages=[
        "git",
        "git-absorb",
        "direnv",
    ],
    no_recommends=True,
)

apt.packages(
    name="Install C & C++ development tools",
    packages=[
        "build-essential",
        "cmake",
        "cmake-qt-gui",
    ],
    no_recommends=True,
)

apt.packages(
    name="Install system administration tools",
    packages=["htop", "nmap"],
    no_recommends=True,
)

apt.packages(
    name="Install modern command line tools",
    packages=[
        "bat",
        "dtrx",
        "eza",
        "fd-find",
        "fzf",
        "jq",
        "ripgrep",
        "trash-cli",
        "wifi-qr",
    ],
    no_recommends=True,
)

apt.packages(
    name="Install libfuse to enable AppImage support",
    packages=[
        "libfuse2t64",
    ],
    no_recommends = True,
)

if not host.get_fact(Which, "bat"):
    which_batcat = host.get_fact(Which, "batcat")
    assert which_batcat, "batcat should have been installed with 'bat'"

    files.link(
        name="Creating symlink for 'batcat' -> 'bat'",
        path="/usr/bin/bat",
        target=which_batcat,
    )

if not host.get_fact(Which, "fd"):
    which_fdfind = host.get_fact(Which, "fdfind")
    assert which_fdfind, "fdfind should have been installed with 'fd-find'"

    files.link(
        name="Creating symlink for 'fdfind' -> 'fd'",
        path="/usr/bin/fd",
        target=which_fdfind,
    )
