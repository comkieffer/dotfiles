from __future__ import annotations

import argparse
import os
import pwd
import sys
from pathlib import Path

from .config import ProgramConfig
from .utils import is_installed
from .action_context import action


def _parse_args(stowable_programs: list[str]) -> argparse.Namespace:
    valid_targets_msg = f"\nValid targets are: {', '.join(stowable_programs)}"

    parser = argparse.ArgumentParser(
        description=(
            "Installer for dotfiles, porcelain around GNU stow invocations."
            + valid_targets_msg
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="Install configuration even if the associated executable is not installed",
    )
    parser.add_argument(
        "-i",
        "--install-recommends",
        action="store_true",
        help="Attempt to install recommended tools.",
    )
    parser.add_argument(
        "-u",
        "--unstow",
        action="store_true",
        help="Remove configuration symlinks instead of installing them.",
    )
    parser.add_argument(
        "--lint",
        action="store_true",
        help="Check that every configured program has a corresponding dotfiles directory.",
    )
    parser.add_argument(
        "targets",
        metavar="TARGET",
        choices=[*stowable_programs, "all"],
        type=str,
        nargs="*",
        help="The configurations to install",
    )
    args = parser.parse_args()

    if not args.lint and not args.targets:
        parser.error("TARGET is required unless --lint is specified")

    if "all" in args.targets:
        args.targets = [*stowable_programs]

    return args


def check_sudo_home_preserved():
    sudo_user = os.environ.get("SUDO_USER")
    if not sudo_user:
        return  # not running under sudo

    current_home = os.environ.get("HOME")
    actual_home = pwd.getpwnam(sudo_user).pw_dir

    if current_home != actual_home:
        print(
            "\033[31mERROR Detected sudo. $HOME ({current_home}) does not match "
            "{sudo_user}'s home {actual_home}.\033[0m"
        )
        print(
            "\033[31mERROR Run with `sudo --preserver-env PATH,HOME` to preserve your "
            "home directory.\033[0m"
        )

        return False

    return True


def install_dotfiles(
    required_dirs: list[str],
    stowable_programs: dict[str, ProgramConfig],
    repo_root: Path,
) -> None:
    args = _parse_args(list(stowable_programs.keys()))

    if args.lint:
        dotfiles_dir = repo_root / "dotfiles"
        missing = [
            name for name in stowable_programs if not (dotfiles_dir / name).is_dir()
        ]
        if missing:
            for name in missing:
                print(
                    f"\033[31mMISSING\033[0m: no dotfiles/{name}/ directory for configured program <{name}>"
                )
            sys.exit(1)
        else:
            print(
                "OK: all configured programs have a corresponding dotfiles directory."
            )
            sys.exit(0)

    if not is_installed("stow"):
        print("Error: `stow` is not installed. Install `stow` to continue.")
        sys.exit(1)

    if args.install_recommends and not check_sudo_home_preserved():
        sys.exit(1)

    valid_targets = []
    for target in args.targets:
        if target not in stowable_programs:
            print(f"\033[31mERROR\033[0m: unknown target <{target}>.")
            continue

        if args.unstow:
            valid_targets.append(target)
        else:
            with action(f"Checking if {target} needs to be installed") as ctx:
                config = stowable_programs[target]
                executable_name = config.executable or target
                if is_installed(executable_name) or args.force:
                    valid_targets.append(target)
                else:
                    ctx.log_info(
                        f"Skipping <{target}>, <{executable_name}> is not in $PATH"
                    )
                    ctx.set_status("SKIP", color="\033[34m")

    if not args.unstow:
        for dir in [Path(p) for p in required_dirs]:
            if not dir.expanduser().is_dir():
                with action(f"Creating {dir}"):
                    dir.expanduser().mkdir(parents=True)

    for target in valid_targets:
        if args.unstow:
            stowable_programs[target].unstow(target, repo_root)
        else:
            stowable_programs[target].install(
                target, args.install_recommends, repo_root
            )

    sys.exit(0)
