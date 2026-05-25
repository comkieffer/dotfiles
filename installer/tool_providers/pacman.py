from __future__ import annotations


def install(package_name: str) -> bool:
    raise NotImplementedError


def find_package_for_file(file: str) -> str | None:
    raise NotImplementedError


def package_satisfies(package_name: str, min_version: tuple[int, ...]) -> bool:
    raise NotImplementedError
