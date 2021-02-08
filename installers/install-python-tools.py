"""
Install all the packages for the base system.

Do not urun this file directly. It won't work. Instead run:

$ pyinfra @local __file__
"""

from pyinfra.operations import apt, pip

USE_SUDO_PASSWORD = True

apt.packages(
    name="Install Packages / Python Tools",
    packages=["python3-venv"],
    latest=True, sudo=True,
)

# TODO: install poetry, black with pipx
pip.packages(
    name="Install Packages / Python Tools Pipx",
    pip="pip3",
    packages=["pipx"],
    latest=True,
)
