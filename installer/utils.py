from __future__ import annotations

import re
import subprocess
import sys


def run_cmd(*args: str) -> tuple[bool, str]:
    ret = subprocess.run(list(args), text=True, capture_output=True)
    if ret.returncode:
        output = (ret.stdout + ret.stderr).strip()
        if output:
            print(f"\033[33m$ {' '.join(args)}\033[0m", file=sys.stderr)
            for line in output.splitlines():
                print(f"  {line}", file=sys.stderr)
    return (not ret.returncode, ret.stdout.strip())

def is_installed(executable: str) -> bool:
    ret = subprocess.run(
        ["which", executable], stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    return not bool(ret.returncode)


def version_satisfies(installed: tuple[int, ...], min: tuple[int, ...]) -> bool:
    n = max(len(installed), len(min))
    return installed + (0,) * (n - len(installed)) >= min + (0,) * (n - len(min))


def parse_version_for_executable(executable: str) -> tuple[int, ...] | None:
    # Need to run in shell so that $PATH is properly resolved (I think)
    status = subprocess.run(
        f"{executable} --version", capture_output=True, text=True, shell=True
    )
    if m := re.search(r"\d+\.\d+(?:\.\d+)?", status.stdout or ""):
        return tuple(int(x) for x in m.group().split("."))
    return None
