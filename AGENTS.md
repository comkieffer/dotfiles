# On Initialisation

- If the repository has an `AGENTS.md` read it.

# Prose Style

- Be direct

# Commit Message Style

- Be direct
- Try the explain the reason for a change more than the contents of the change
- Do not add attribute the commit to yourself

# Workflow

- When making a change, explain the resoning for the change before asking to execute the change.
- If the repository has a .pre-commit-config.yml file, run `pre-commit --show-diff-on-faliure --files CHANGED_FILES` to lint the code, and address any issues in sections you changed.
- If the repository has a `justfile`, use that to run common commands
- If the repository has a `pyproject.toml` file read it to see if the it uses `poetry` or `uv`
- If the project uses `pytest`, run tests (with `uv` or `poetry` after making changes)

# Learning

- If you make a mistake, suggest creating a memory to avoid making the same mistake in the future.
