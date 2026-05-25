from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path

from .packages import install_binary, is_installed, package_satisfies
from .action_context import ActionContext, action
from .utils import run_cmd


@dataclass
class Recomends:
    name: str

    # Candidates are either bare file paths (implicit file://) or ubi:// URIs.
    candidates: tuple[str, ...] = ()
    min_version: tuple[int, ...] | None = None


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
    recommended_binaries: list[Recomends] = field(default_factory=list)

    def install(self, target: str, install_recommends: bool) -> None:
        for dir in [Path(p) for p in self.create_dirs]:
            if not dir.expanduser().is_dir():
                with action(f"Creating {dir}"):
                    dir.expanduser().mkdir(exist_ok=True, parents=True)

        with action(f"Installing configurations for {target}", container=True) as root_ctx:
            run_cmd("stow", "--target", str(Path.home()), "--restow", target)

            if self.post_install:
                with action(f"Running {' '.join(self.post_install)}", parent=root_ctx) as ctx:
                    ret = run_cmd(self.post_install)
                    ctx.log_info(ret.stdout.strip())

            if self.recommended_binaries:
                if install_recommends:
                    self._install_recommends(root_ctx, self.recommended_binaries)
                else:
                    self._check_recommends(root_ctx, self.recommended_binaries)

    def _install_recommends(self, parent_ctx: ActionContext, recommended_binaries: list[Recomends]) -> None:
        with action(
            "Installing recommended binaries", parent=parent_ctx, container=True
        ) as install_ctx:
            for rec_binary in recommended_binaries:
                with action(f"Installing {rec_binary.name}", parent=install_ctx) as ctx:
                    if is_installed(rec_binary.name):
                        ctx.set_status("SKIPPED", color="\033[32m", reason="(PRESENT)")
                    elif not install_binary(ctx, rec_binary):
                        ctx.set_status("FAILED", color="\033[31m")

    def _check_recommends(self, parent_ctx: ActionContext, recommended_binaries: list[Recomends]) -> None:
        with action(
            "Checking status of recommended binaries",
            parent=parent_ctx,
            container=True,
        ) as install_ctx:
            for rec_binary in recommended_binaries:
                with action(f"Checking {rec_binary.name}", parent=install_ctx) as ctx:
                    if not is_installed(rec_binary.name):
                        ctx.set_status("MISSING", "\033[31m")
                    elif (
                        rec_binary.min_version is not None
                        and not package_satisfies(rec_binary.name, rec_binary.min_version)
                    ):
                        ctx.set_status("WRONG VER", "\033[33m")
                    else:
                        ctx.set_status("FOUND", "\033[32m")
