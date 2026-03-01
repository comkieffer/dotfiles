import textwrap

from pyinfra import host, logger
from pyinfra.operations import apt, files, server, systemd
from pyinfra.facts.server import Users

# Note: still need to add the user to the group
apt.packages(
	name="Install docker",
	packages=[
		"docker.io",
		"docker-buildx",
		"docker-compose",
		"fuse-overlayfs",
	],
)

files.directory(
	name="Create /etc/docker directory",
	path="/etc/docker",
	present=True,
	mode="755",
)

files.put(
	name="Configure Docker log rotation",
	src=None,
	dest="/etc/docker/daemon.json",
	mode="644",
	create_remote_dir=False,
	_content=textwrap.dedent("""\
		{
		  "log-driver": "json-file",
		  "log-opts": {
		    "max-size": "100m",
		    "max-file": "3"
		  }
		}
		"""),
)

systemd.service(
	name="Restart Docker to apply log rotation settings",
	service="docker",
	restarted=True,
)

server.group(name="Create docker group", group="docker")
