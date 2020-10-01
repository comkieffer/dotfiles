from pyinfra.operations import apt

USE_SUDO_PASSWORD=True

apt.ppa(
    name="Install Package / Regolith Linux / Add PPA",
    src="ppa:regolith-linux/release",
    sudo=True,
)

# TODO: install i3bar applets 
apt.packages(
    name="Install Package / Regolith Linux / Install Package",
    packages="regolith-desktop",
    latest=True, sudo=True, update=True,
)

# TODO: check if this is still required, VPN has isssues on Ubuntu 18.04, maybe fixed in 20.04 ?
# See: https://github.com/regolith-linux/regolith-desktop/issues/64
apt.packages(
    name="Install Package / Regolith Linux / VPN Support",
    packages="network-manager-openconnect-gnome",
    latest=True, sudo=True,
)

# Gnome bundles a night-light/f.lux clone so we shouldn't download this in the general case. 
# When we're using regolith/i3 though, then we really want it.
# TODO: add redshift to i3 conf (exec)
apt.packages(
    name="Install Package / Regolith Linux / Redshift",
    packages="redshift",
    latest=True, sudo=True,
)
