from pathlib import Path

from pyinfra import local


source_dir = Path(__file__).resolve().parent
system_install_scripts_dir = Path("system")

for py_file in (source_dir / system_install_scripts_dir).glob("*.py"):
    local.include(system_install_scripts_dir / py_file)
