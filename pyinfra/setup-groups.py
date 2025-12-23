from pyinfra import host
from pyinfra.operations import server
from pyinfra.facts.server import Users

users = host.get_fact(Users)

def add_to_group(user: str, group: str):
    if "tch" in users and group not in users["tch"]["groups"]:
        server.user(
            name=f"Add '{user}' to {group} group",
            user=user,
            groups=users[user]["groups"] + [group]
    )


# Add use to dialout group
# Required to access serial devices
add_to_group("tch", "dialout")

# Add user to video group for brightness control
# Required for lightctl/brightnessctl to access /sys/class/backlight/*/brightness
add_to_group("tch", "video")
