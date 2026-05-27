from __future__ import annotations

import functools
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .config import Recommends

from .action_context import ActionContext
from .utils import Version, run_cmd


def _distro() -> str:
    _, distribution = run_cmd("lsb_release", "--id", "--short")
    return distribution


@functools.cache
def _package_manager():
    match _distro():
        case "Ubuntu":
            from .tool_providers import apt

            return apt
        case "Arch Linux":
            from .tool_providers import pacman

            return pacman
        case distro:
            raise RuntimeError(f"Unsupported distro: {distro}")


def find_package_for_file(file: str) -> str | None:
    return _package_manager().find_package_for_file(file)


def install_package(package_name: str) -> tuple[bool, str]:
    return _package_manager().install(package_name)


def package_satisfies(package_name: str, min_version: Version) -> bool:
    return _package_manager().package_satisfies(package_name, min_version)


def _install_with_package_manager(
    ctx: ActionContext, binary: Recommends, value: str
) -> bool:
    if not (package_name := find_package_for_file(value)):
        ctx.set_status("NOT FOUND", color="\033[33m")
        return False

    if binary.min_version is not None and not package_satisfies(
        package_name, binary.min_version
    ):
        ctx.log_warning(
            f"Version of {binary.name} in distribution repos does not match "
            "version requirement."
        )
        ctx.set_status("WRONG VER", color="\033[33m")
    else:
        status, output = install_package(package_name)
        if status:
            ctx.log_info(f"Installed package {package_name}")
            return True

        ctx.log_error(f"Unable to install package {package_name} for '{value}'")
        ctx.log_error(output)
        ctx.set_status("FAILED", color="\033[31m")

    return False


def install_binary(ctx: ActionContext, binary: Recommends) -> bool:
    for candidate in binary.candidates:
        if _install_with_package_manager(ctx, binary, candidate):
            return True

    return False
