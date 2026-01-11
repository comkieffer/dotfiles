from pyinfra import host
from pyinfra.operations import apt, files
from pyinfra.facts.server import Which

# Note: pipx is installed by the boostrap script.

apt.update(name="Update apt repositories", cache_time=3600)

apt.packages(
    name="Install core tools",
    packages=[
        "curl",
        "fish",
        "gimp",
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

# Create symlinks for renamed binaries if they don't already exist
# Note: In newer Ubuntu versions, bat and fd-find may install directly as bat/fd
files.link(
    name="Creating symlink for 'batcat' -> 'bat'",
    path="/usr/bin/bat",
    target="/usr/bin/batcat",
    present=True,
)

files.link(
    name="Creating symlink for 'fdfind' -> 'fd'",
    path="/usr/bin/fd",
    target="/usr/bin/fdfind",
    present=True,
)
