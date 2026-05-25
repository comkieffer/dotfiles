from __future__ import annotations

import sys
import textwrap
from contextlib import contextmanager
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from typing import Generator


class ActionContext:
    def __init__(self, parent: ActionContext | None = None) -> None:
        self._status: str | None = None
        self._line_open: bool = False
        self.depth: int = parent.depth + 1 if parent else 0

    def set_status(
        self, message: str, color: str = "\033[32m", reason: str = ""
    ) -> None:
        self._status = f"{color}{message}\033[0m {reason}"

    def _break_line(self) -> None:
        if self._line_open:
            print()
            self._line_open = False

    def log_debug(self, message: str) -> None:
        self._break_line()
        print(textwrap.indent(message, "  " * (self.depth + 2)))

    def log_info(self, message: str) -> None:
        self._break_line()
        print(textwrap.indent(message, "  " * (self.depth + 2)))

    def log_warning(self, message: str) -> None:
        self._break_line()
        print(
            "\033[33m" + textwrap.indent(message, "  " * (self.depth + 2)) + "\033[0m"
        )

    def log_error(self, message: str) -> None:
        self._break_line()
        print(
            "\033[31m" + textwrap.indent(message, "  " * (self.depth + 2)) + "\033[0m"
        )


@contextmanager
def action(
    name: str, parent: ActionContext | None = None, container: bool = False
) -> Generator[ActionContext, None, None]:
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
    ctx = ActionContext(parent)
    print(
        f"{'  ' * ctx.depth}- {name} ".ljust(60, "."),
        end="\n" if container else "",
        flush=True,
    )

    ctx._line_open = not container

    caught: Exception | None = None
    try:
        yield ctx
    except Exception as exc:
        caught = exc

    if not container:
        default = "\033[31mFAIL\033[0m" if caught else "\033[32mOK\033[0m"
        status_str = ctx._status or default
        if ctx._line_open:
            print(f" {status_str}")
        else:
            print("  " * (ctx.depth + 2) + status_str)
        ctx._line_open = False

    if caught:
        if not ctx._status:
            print(str(caught))
        sys.exit(-1)
