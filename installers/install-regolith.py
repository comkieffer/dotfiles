"""
Install Regolith packages.

Do not urun this file directly. It won't work. Instead run:

$ pyinfra @local __file__
"""

from pyinfra.operations import apt

USE_SUDO_PASSWORD=True

# For laptops
REGOLITH_VARIANT = "regolith-desktop-mobile"

# For desktops
# REGOLITH_VARIANT = "regolith-desktop"

apt.ppa(
    name="Install Package / Regolith Linux / Add PPA",
    src="ppa:regolith-linux/stable",
    sudo=True,
)

# TODO: install i3bar applets
apt.packages(
    name="Install Package / Regolith Linux / Install Package",
    packages=REGOLITH_VARIANT,
    latest=True, sudo=True, update=True,
)

# apt.packages(
#     name="Install Package / Regolith Linux / Install Blocklets",
#     packages=[
#         "i3xrocks-battery", "i3xrocks-media-player", "i3xrocks-nm-vpn",
#         "i3xrocks-time",  "i3xrocks-volume", "i3xrocks-wifi",
#     ],
#     latest=True, sudo=True,
# )

# TODO: check if this is still required, VPN has isssues on Ubuntu 18.04, maybe fixed in 20.04 ?
# See: https://github.com/regolith-linux/regolith-desktop/issues/64
#
# Current state: Cannot start VPn from network interface in gnome settings.
#   Maybe installing network-manager-openvpn is requried?
# apt.packages(
#     name="Install Package / Regolith Linux / VPN Support",
#     packages=[
#         "network-manager-openvpn",  "network-manager-openvpn-gnome",
#     ],
#     latest=True, sudo=True,
# )

# Gnome bundles a night-light/f.lux clone so we shouldn't download this in the general case.
# When we're using regolith/i3 though, then we really want it.
# TODO: add redshift to i3 conf (exec)
# apt.packages(
#     name="Install Package / Regolith Linux / Redshift",
#     packages="redshift",
#     latest=True, sudo=True,
# )
