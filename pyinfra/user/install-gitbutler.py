
from pyinfra.operations import files, apt

DOWNLOAD_DIR = "/tmp/gitbutlerapp/"

files.directory(
    name="Creating download directory",
    path=DOWNLOAD_DIR,
)


apt.deb(
    name="Install gitbutler package",
    src="https://app.gitbutler.com/downloads/release/linux/x86_64/deb",
    _sudo=True,
)
