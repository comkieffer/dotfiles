from pyinfra import host, logger
from pyinfra.operations import apt, server
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

server.group(name="Create docker group", group="docker")

users = host.get_fact(Users)

if "tch" in users and "docker" not in users["tch"]["groups"]:
    server.user(
        name="Add 'tch' to docker group",
        user="tch",
        groups=users["tch"]["groups"] + ["docker"]
    )
