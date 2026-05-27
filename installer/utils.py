from __future__ import annotations

import re
import subprocess
from functools import total_ordering


@total_ordering
class Version:
    def __init__(self, parts: tuple[int, ...]) -> None:
        self._parts = parts

    def __str__(self) -> str:
        return ".".join(str(p) for p in self._parts)

    def __eq__(self, other: object) -> bool:
        if isinstance(other, Version):
            if len(self._parts) != len(other._parts):
                raise ValueError(
                    f"Cannot compare versions of different lengths: {self} vs {other}"
                )
            return self._parts == other._parts
        return NotImplemented

    def __lt__(self, other: Version) -> bool:
        if len(self._parts) != len(other._parts):
            raise ValueError(
                f"Cannot compare versions of different lengths: {self} vs {other}"
            )
        return self._parts < other._parts

    @classmethod
    def from_string(cls, version_str: str) -> Version:
        return cls(tuple(int(x) for x in version_str.split(".")))


def run_cmd(*args: str, shell: bool = False) -> tuple[bool, str]:
    ret = subprocess.run(list(args), text=True, capture_output=True, shell=shell)
    output = (ret.stdout + ret.stderr).strip()

    return (not ret.returncode, output)


def is_installed(executable: str) -> bool:
    ret = subprocess.run(["which", executable], capture_output=True)
    return not bool(ret.returncode)


def parse_version_for_executable(executable: str) -> Version | None:
    # Need to run in shell so that $PATH is properly resolved (I think)
    status = subprocess.run(
        f"{executable} --version", capture_output=True, text=True, shell=True
    )
    if m := re.search(r"\d+\.\d+(?:\.\d+)?", status.stdout or ""):
        return Version(tuple(int(x) for x in m.group().split(".")))

    return None
