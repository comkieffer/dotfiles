from __future__ import annotations

from dataclasses import dataclass, field
from collections.abc import Sequence
from pathlib import Path
from typing import Any

from .packages import install_binary, package_satisfies
from .action_context import ActionContext, action
from .utils import is_installed, run_cmd, parse_version_for_executable, Version

DEFAULT_BIN_PATH = Path("/usr/bin/")


class Recommends:
    """A binary recommended by a program configuration.

    Attributes:
        name: The name of the tool.
        binary:
            The name of the actual binary. Defaults to name, but can be overridden when
            the tool provides a binary with a different name (e.g. difftastic -> difft).
        candidates: Paths at which the binary might be found.
        min_version: Minimum required version, if any.
    """

    def __init__(
        self,
        name: str,
        candidates: Sequence[str] = (),
        min_version: str | Version | None = None,
        binary: str | None = None,
    ) -> None:
        self.name = name
        self.binary = binary if binary is not None else name
        self.min_version = (
            Version.from_string(min_version)
            if isinstance(min_version, str)
            else min_version
        )
        self.candidates = (
            tuple(candidates) if candidates else (str(DEFAULT_BIN_PATH / self.binary),)
        )


def _flatten_dict(d: dict[Any, Any]) -> list[Any]:
    return [x for pair in d.items() for x in pair]


@dataclass
class ProgramConfig:
    # Before installing a configuration, the tool checks that the associated binary is
    # installed. The executable name defaults to the program name; set this when they
    # differ (e.g. the helix editor binary is hx).
    executable: str | None = None

    # Directories to create before running stow, so that stow creates symlinks to
    # files inside the directory rather than a symlink to the directory itself.
    create_dirs: list[str] = field(default_factory=list)

    # Commands to run after stow, e.g. to sync plugin manifests.
    post_install: list[str] = field(default_factory=list)

    # Binaries recommended for this configuration to work well.
    recommended_binaries: list[Recommends] = field(default_factory=list)

    def unstow(self, target: str, repo_root: Path) -> None:
        with action(f"Unstowing configurations for {target}") as ctx:
            stow_args = {
                "--dir": str(repo_root / "dotfiles"),
                "--target": str(Path.home()),
                "--delete": target,
            }

            ret, stdout = run_cmd("stow", *_flatten_dict(stow_args))
            if not ret:
                ctx.log_error(f"Unable to unstow target {target}.")
                ctx.log_error(stdout)

    def install(self, target: str, install_recommends: bool, repo_root: Path) -> None:
        for dir in [Path(p) for p in self.create_dirs]:
            if not dir.expanduser().is_dir():
                with action(f"Creating {dir}"):
                    dir.expanduser().mkdir(exist_ok=True, parents=True)

        with action(f"Installing configurations for {target}") as ctx:
            stow_args = {
                "--dir": str(repo_root / "dotfiles"),
                "--target": str(Path.home()),
                "--restow": target,
            }

            ret, stdout = run_cmd("stow", *_flatten_dict(stow_args))
            if not ret:
                ctx.log_error(f"Unable to stow target {target}.")
                ctx.log_error(stdout)

        if self.post_install:
            with action("Running post-install scripts", container=True) as postinst_ctx:
                msg = f"Running {' '.join(self.post_install)}"
                with action(msg, parent=postinst_ctx) as ctx:
                    for post_install_cmd in self.post_install:
                        _, stdout = run_cmd(post_install_cmd, shell=True)
                        ctx.log_info(stdout)

        if self.recommended_binaries:
            if install_recommends:
                self._install_recommends(self.recommended_binaries)
            else:
                self._check_recommends(self.recommended_binaries)

    def _install_recommends(self, recommended_binaries: list[Recommends]) -> None:
        with action("Installing recommended binaries", container=True) as install_ctx:
            for rec_binary in recommended_binaries:
                with action(f"Installing {rec_binary.name}", parent=install_ctx) as ctx:
                    if is_installed(rec_binary.binary):
                        ctx.set_status("SKIPPED", color="\033[32m", reason="(PRESENT)")
                    else:
                        install_binary(ctx, rec_binary)

    def _check_recommends(self, recommended_binaries: list[Recommends]) -> None:
        msg = "Checking status of recommended binaries"
        with action(msg, container=True) as install_ctx:
            for rec_binary in recommended_binaries:
                msg = f"Checking {rec_binary.name}"
                if rec_binary.min_version:
                    msg += f" (> {str(rec_binary.min_version)})"
                with action(msg, parent=install_ctx) as ctx:
                    self._check_one_recommend(ctx, rec_binary)

    def _check_one_recommend(self, ctx: ActionContext, rec: Recommends) -> None:
        if not is_installed(rec.binary):
            ctx.set_status("MISSING", "\033[31m")
            return

        installed_version = parse_version_for_executable(rec.binary)
        _, binary_path = run_cmd(f"which {rec.binary}", shell=True)

        # Things under `~` are assumed to be user-installed, not package-managed.
        if (
            rec.min_version is not None
            and not Path(binary_path).is_relative_to(Path("~").expanduser())
            and not package_satisfies(rec.name, rec.min_version)
        ):
            ctx.set_status(
                "WRONG VER", "\033[33m", reason=f" ver {installed_version!s}"
            )
        else:
            ctx.set_status("FOUND", "\033[32m", reason=f" ver {installed_version!s}")
