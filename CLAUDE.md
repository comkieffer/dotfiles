# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository for Linux system configuration. It uses GNU Stow for symlink management and pyinfra for system provisioning.

## Architecture

### Stow-based Structure
The repository is organized into application-specific directories (e.g., `fish/`, `git/`, `tools/`, `regolith/`). Each directory contains files that mirror the target location in the home directory. For example:
- `fish/.config/fish/config.fish` → `~/.config/fish/config.fish`
- `tools/.local/bin/todo` → `~/.local/bin/todo`

### Installation System
The `./install` script (Python) wraps GNU Stow with custom rules defined in `STOWED_PROGRAMS`. Key features:
- Only installs configurations if the associated executable is present
- Creates required directories before stowing (prevents directory symlinks)
- Runs post-install hooks (e.g., `fisher update` for Fish plugins)

### System Provisioning
The `bootstrap` script sets up the system using pyinfra:
1. Creates a Python venv at `.venv/`
2. Installs pyinfra into the venv
3. Runs pyinfra scripts from `pyinfra/` directory

Pyinfra scripts handle package installation and system configuration.

### Reminder System
Reminder files in `tools/.local/share/reminders/` use a specific format:
- First non-empty line: Title
- Rest of file: Content (supports Rich markup like `[bold]`, `[cyan]`, etc.)

When adding a new tool, it is good practice to add a reminder file for it. Look at existing reminder files for style and content.


## Development Notes

When adding python scripts:

- Use argparse for argument handling in a dedicated `parse_args()` function
- Where possible, use only stdlib function, when using outisde functions, provide a fallback using stdlib functions
- Support Rich markup for terminal output when the `rich` library is available
- Make scripts executable and use appropriate shebang (`#!/usr/bin/env python3`)

After making changes, run `pre-commit` on the changed files.
