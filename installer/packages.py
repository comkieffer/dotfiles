from __future__ import annotations

import functools
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .config import Recomends

from .action_context import ActionContext
from .utils import is_installed, parse_version_for_executable, run_cmd, version_satisfies


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


def install_package(package_name: str) -> bool:
    return _package_manager().install(package_name)


def package_satisfies(package_name: str, min_version: tuple[int, ...]) -> bool:
    return _package_manager().package_satisfies(package_name, min_version)


def _install_with_ubi(ctx: ActionContext, binary: Recomends, project: str) -> bool:
    if not is_installed("ubi"):
        ctx.log_warning(f"'ubi' is not installed, skipping ubi://{project}")
        return False

    ok, _ = run_cmd("ubi", "--project", project)
    if not ok:
        ctx.log_warning(f"Unable to install '{project}' with ubi.")
        return False

    # ubi can't check version before installing, so verify after the fact.
    installed_version = parse_version_for_executable(binary.name)
    if binary.min_version and not version_satisfies(installed_version, binary.min_version):
        ctx.log_warning(
            f"Version of {binary.name} installed with ubi "
            f"({installed_version}) does not satisfy requirement "
            f"({binary.min_version})"
        )
    return True

def _install_with_package_manager(ctx: ActionContext, binary: Recomends, value: str) -> bool:
    if package_name := find_package_for_file(value):
        if binary.min_version and not package_satisfies(package_name, binary.min_version):
            ctx.log_warning(
                f"Version of {binary.name} in distribution repos does not match "
                "version requirement."
            )
        else:
            if install_package(package_name):
                return True
            else:
                ctx.log_error(
                    f"Unable to install package {package_name} for '{value}'"
                )

    return False

def _candidate_protocol(candidate: str) -> tuple[str, str]:
    """Split a candidate into (protocol, value), defaulting to file:// if absent."""
    if "://" in candidate:
        protocol, _, value = candidate.partition("://")
        return protocol, value
    return "file", candidate


def install_binary(ctx: ActionContext, binary: Recomends) -> bool:
    for candidate in binary.candidates:
        protocol, value = _candidate_protocol(candidate)
        match protocol:
            case "ubi":
                if _install_with_ubi(ctx, binary, value):
                    return True
            case "file":
                if _install_with_package_manager(ctx, binary, value):
                    return True

    ctx.log_error(f"Unable to find a package for {binary.name}")
    return False
