from io import StringIO

from pyinfra import host
from pyinfra.facts.snap import SnapPackages
from pyinfra.operations import apt, snap
from pyinfra.operations.server import files


if "firefox" in host.get_fact(SnapPackages):
    apt.ppa(
        name="Install firefox ppa",
        src="ppa:mozillateam/ppa",
    )

    files.put(
        name="Use firefox from ppa",
        src=StringIO(
            """
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox
Pin: version 1:1snap*
Pin-Priority: -1
            """
        ),
        dest="/etc/apt/preferences.d/mozilla-firefox",
    )

    snap.package(
        name="Remove firefox snap",
        packages="firefox",
        present=False,
    )

    apt.packages(
        name="Install firefox package",
        packages="firefox",
        present=False,
    )

    apt.packages(
        name="Install firefox package",
        packages="firefox",
    )
