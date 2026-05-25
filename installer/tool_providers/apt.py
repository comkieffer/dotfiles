from __future__ import annotations

import re

from ..utils import run_cmd, version_satisfies


def install(package_name: str) -> bool:
    ok, _ = run_cmd("apt-get", "-yqq", "install", package_name)
    return ok


def find_package_for_file(file: str) -> str | None:
    packages = []
    _, output = run_cmd("apt-file", "find", file)
    for line in output.splitlines():
        package, _ = line.split(":")
        packages.append(package.strip())

    unique_packages = set(packages)
    if len(unique_packages) == 1:
        return next(iter(unique_packages))

    # If we have multiple packages to install, then we do not know which one to pick.
    # Until we have better error handling, we return None.
    return None


def package_satisfies(package_name: str, min_version: tuple[int, ...]) -> bool:
    ok, stdout = run_cmd("apt", "policy", package_name)
    assert ok, "apt policy failed."

    if m := re.search(r"Candidate:\s*(\d+\.\d+(?:\.\d+)?)", stdout):
        package_version = tuple(int(x) for x in m.group(1).split("."))
        return version_satisfies(package_version, min_version)

    assert False, "The regex should have matched."
