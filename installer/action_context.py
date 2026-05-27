from __future__ import annotations

import sys
import textwrap
from contextlib import contextmanager
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from collections.abc import Generator


class ActionContext:
    def __init__(
        self,
        name: str,
        parent: ActionContext | None = None,
        container: bool = False,
    ) -> None:
        self._status: str | None = None
        self._container = container
        self.depth: int = parent.depth + 1 if parent else 0
        self._cached_logs: list[tuple[str, str]] = []

        print(
            f"{'  ' * self.depth}- {name} ".ljust(60, "."),
            end="\n" if container else "",
            flush=True,
        )

    def set_status(
        self, message: str, color: str = "\033[32m", reason: str = ""
    ) -> None:
        self._status = f"{color}{message:<10}\033[0m {reason}"

    def _format(self, message: str, color: str = "") -> str:
        indented = textwrap.indent(message, "  " * (self.depth + 2))
        return f"{color}{indented}\033[0m" if color else indented

    def _log(self, message: str, color: str = "") -> None:
        if self._container:
            print(self._format(message, color))
        else:
            self._cached_logs.append((message, color))

    def finish(self, caught: Exception | None) -> None:
        # Containers make printing the status too difficult (since they add extra lines
        # to the output), so we just don't.
        if not self._container:
            default = "\033[31mFAIL\033[0m" if caught else "\033[32mOK\033[0m"
            print(f" {self._status or default}")
            for log in self._cached_logs:
                print(self._format(*log))

        if caught:
            if not self._status:
                print(str(caught))
            sys.exit(-1)

    def log_debug(self, message: str) -> None:
        self._log(message)

    def log_info(self, message: str) -> None:
        self._log(message)

    def log_warning(self, message: str) -> None:
        self._log(message, "\033[33m")

    def log_error(self, message: str) -> None:
        self._log(message, "\033[31m")


@contextmanager
def action(
    name: str, parent: ActionContext | None = None, container: bool = False
) -> Generator[ActionContext]:
    """
    Context manager to show status for an action.

    Example:

        Do action A ...................... OK
        Do action B ...................... FAILED

    The context manager can be nested to represent groups of actions (container=True)

        Do action group ..................
          Do thing that might fail ....... FAILED
          Do thing that worked ........... OK

        with action("Do action group", container=True) as root:
            with action("Do thing that might fail", parent=root):
                pass

            with action("Do thing that worked", parent=root):
                pass
    """
    ctx = ActionContext(name, parent, container)
    caught: Exception | None = None
    try:
        yield ctx
    except Exception as exc:
        caught = exc
    ctx.finish(caught)
