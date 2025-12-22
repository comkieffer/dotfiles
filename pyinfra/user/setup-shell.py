import re

from pathlib import Path
from string import Template

import requests


from pyinfra import host, logger
from pyinfra.api import OperationError
from pyinfra.facts.server import Home, Which
from pyinfra.operations import apt, files, server, python

HOMEDIR = host.get_fact(Home)

server.files.directory(name="Create .local/bin", path=f"{HOMEDIR}/.local/bin")


def download_latest_release_metadata(gh_group, gh_project):
    releases_url = (
        f"https://api.github.com/repos/{gh_group}/{gh_project}/releases/latest"
    )

    response = requests.get(releases_url)
    response.raise_for_status()

    release_metadata = response.json()
    return release_metadata


def get_matched_release_asset(release_metadata, matcher: str) -> dict[str, str | int]:
    matched_assets = [
        asset
        for asset in release_metadata["assets"]
        if re.search(matcher, asset["name"])
    ]

    match len(matched_assets):
        case 0:
            raise OperationError(f"No assets match the regular expression '{matcher}'.")
        case 1:
            return matched_assets[0]
        case _:
            logger.error(
                "Regular expression '{asset_matcher}'' matched multiple assets:"
            )
            for asset in matched_assets:
                logger.error(f" - {asset["name"]}")

            raise OperationError(f"Multiple assets match the regular expression '{matcher}'.")


def download_and_install(
    gh_group: str,
    gh_project: str,
    asset_matcher: str,
    *,
    command: str | None = None,
    version: str = "latest",
    post_install: list[str] | None = None,
):
    """
    Args:
        gh_group:
            The group under which the project can be found on github (usually the user
            name of the user the created the project).
        gh_project:
            The project name on github
        asset_matcher:
            A regular expression to select the correct asset from the release. This
            should match exactly one asset.
        post_install:
            A series of commands to run after downloading the file (_e.g._ to unpack
            an archive, or install a binary). The downloaded file is automatically
            removed when the command exits.

            If the argument is ``None``, some simple cases are handled automatically:

            - If the downloaded file is a ``.deb``, the package is installed.
            - If the downloaded file is a tar.gz, the file is unpacked, and any
              binaries are installed to ``.local/bin``.`

        command:
            The name of the command installed by the project. If unspecified, the
            project name is used instead.
        version:
            The expected version of the tool. If 'latest' is used, the version is
            retrieved from the github release.
    """

    # Use the project name if the command is not used.
    if command is None:
        command = gh_project

    release_metadata = download_latest_release_metadata(gh_group, gh_project)
    if version == "latest":
        version = release_metadata["tag_name"]
        logger.info(f"Latest version of {gh_project} is {version}")

    # If the command is not installed, we need to download it for sure.
    version_command = server.shell(
        name=f"Checking installed version of {command}",
        commands=f"command -v {command} && {command} --version || true",
    )

    def download_if_not_up_to_date():
        # If the version is specified with a 'v' prefix, we strip it, because the
        # prefix is often not printed when showing the version in CLI output.
        version_str = version[1:] if version[0] == "v" else version

        # If we see the version number in the output, then we can assume that we
        # have the correct version installed.
        if version_command.did_succeed:
            # Let's try to get the actual version number. If the tool is well
            # behaved, the version number should be on a line that starts with the
            # command name.
            command_version = None
            stdout_lines = version_command.stdout.split("\n")
            for l in stdout_lines:
                if l.strip().startswith(command):
                    _, command_version = l.strip().split(" ", maxsplit=2)

            if version_str in version_command.stdout:
                logger.info("{command} is already up-to-date.")
                return
            else:
                logger.info(f"Installed version of {command} is {command_version}.")
        else:
            logger.info(f"{command} is not installed.")

        # We need to download and install the package.
        asset_metadata = get_matched_release_asset(release_metadata, asset_matcher)

        downloaded_file = Path(f"/tmp/{gh_group}/{gh_project}/{asset_metadata["name"]}")

        server.files.directory(
            name=f"Create download directory {downloaded_file.parent}",
            path=downloaded_file.parent,
        )

        asset_downloaded = files.download(
            name=f"Downloading release {version}",
            src=asset_metadata["browser_download_url"],
            dest=str(downloaded_file),
        )

        if post_install is None:

            logger.info(f"Executing pre-baked rules with {downloaded_file.suffixes=}")
            match downloaded_file.suffixes:
                case [".deb"]:
                    apt.deb(
                        name="Install downloaded poackage",
                        src=downloaded_file,
                    )
                case [*rest, ".tar", ".gz"] | [*rest, ".tar", ".xz"]:
                    match downloaded_file.suffixes[-1]:
                        case ".xz":
                            compression_flag = "J"
                        case ".gz":
                            compression_flag = "z"

                    unpacked_dir = downloaded_file.parent / downloaded_file.stem
                    server.shell(
                        name="Unpacking downloaded archive and installing binaries",
                        commands=[
                            f"mkdir -p {unpacked_dir}",
                            f"tar -x{compression_flag}vf {downloaded_file} -C {unpacked_dir}",
                            f"find {unpacked_dir} -type f -executable -execdir mv {{}} {HOMEDIR}/.local/bin \;",
                        ],
                    )
                case _:
                    logger.info(f"No handler for {downloaded_file} ({downloaded_file.suffixes})")
        else:
            commands = [
                Template(c).safe_substitute(file=downloaded_file) for c in post_install
            ]

            logger.info(f"{commands}")

            server.shell(name="Running post_install commands", commands=commands)

        server.shell(
            name="Removing downloaded file",
            commands=["rm -rf {downloaded_file.parent}"],
        )

    python.call(
        name="Download assets if required",
        function=download_if_not_up_to_date,
    )

    server.shell(
        name="Checking that tool was installed successfully.",
        commands=[
            f"{command} --version",
        ],
    )

    return



download_and_install(
    "pythops",
    "bluetui",
    asset_matcher="x86_64",
    post_install=[
        "chmod 755 $file",
        "mv $file $HOME/.local/bin/bluetui",
    ],
)

# Note: helix will always be re-downloaded because the version in the in tag has
# leading zeros
download_and_install("helix-editor", "helix", command="hx", asset_matcher="x86_64-linux")

download_and_install("casey", "just", asset_matcher="x86_64-unknown-linux-musl")

download_and_install(
    "starship", "starship", asset_matcher="x86_64-unknown-linux-musl.tar.gz$"
)

download_and_install("ajeetdsouza", "zoxide", asset_matcher="x86_64")
