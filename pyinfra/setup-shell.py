from pyinfra.operations import apt, files, server 

STARSHIP_BASE_URL="https://github.com/starship/starship/releases"
STARSHIP_VERSION="latest"
STARSHIP_TARGET="x86_64-unknown-linux-musl"

tool_downloaded = files.download(
    name="Download starship.rs",
    src=f"{STARSHIP_BASE_URL}/{STARSHIP_VERSION}/download/starship-{STARSHIP_TARGET}.tar.gz",
    dest=f"/tmp/starship.tar.gz"
)

if tool_downloaded.changed:
    server.shell(
        name="Unpack starship archive and install it",
        commands=[
            "tar -xvf /tmp/starship.tar.gz",
            "mv starship ~/.local/bin/starship",
            "rm /tmp/starship.tar.gz",
        ]
    )

ZOXIDE_BASE_URL="https://github.com/ajeetdsouza/zoxide/releases"
ZOXIDE_VERSION="0.9.8"
ZOXIDE_TARGET="x86_64-unknown-linux-musl"

tool_downloaded = files.download(
    name="Download zoxide.rs",
    src=f"{ZOXIDE_BASE_URL}/download/v{ZOXIDE_VERSION}/zoxide-{ZOXIDE_VERSION}-{ZOXIDE_TARGET}.tar.gz",
    dest=f"/tmp/zoxide.tar.gz"
)

if tool_downloaded.changed:
    server.shell(
        name="Unpack zoxide archive and install it",
        commands=[
            "tar -xvf /tmp/zoxide.tar.gz",
            "mv zoxide ~/.local/bin/zoxide",
            "rm /tmp/zoxide.tar.gz"
        ]
    )

