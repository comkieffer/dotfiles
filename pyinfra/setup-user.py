from pathlib import Path

from pyinfra import local


source_dir = Path(__file__).resolve().parent
user_install_scripts_dir = Path("user")

for py_file in (source_dir / user_install_scripts_dir) .glob("*.py"):
    local.include(user_install_scripts_dir / py_file)
