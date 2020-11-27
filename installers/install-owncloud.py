"""
Install Owncloud-Dektop packages.

Do not run this file directly. It won't work. Instead run:

$ pyinfra @local __file__
"""

from pyinfra.operations import apt

USE_SUDO_PASSWORD = True

apt.key(
    name="Install Packages / Owncloud / Add GPG Key",
    src="https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Ubuntu_20.04/Release.key",
    sudo=True,
)

apt.repo(
    name="Install Packages / Owncloud / Add Repo",
    src="deb https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Ubuntu_20.04/ /",
    filename="owncloud",
    sudo=True,
)

apt.packages(
    name="Install Packages / Owncloud / Install Package",
    packages=["owncloud-client"],
    sudo=True, update=True,
)
