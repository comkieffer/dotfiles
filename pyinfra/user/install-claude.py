from pyinfra.operations import files, server

file_downloaded = files.download(
    name="Download claude install script",
    src="https://claude.ai/install.sh",
    dest="/tmp/claude-install.sh",
    mode="755",
)

if file_downloaded:
    server.shell(
        name="Run install script",
        commands=[
            "/tmp/claude-install.sh",
            "rm /tmp/claude-install.sh"
        ],
    )
