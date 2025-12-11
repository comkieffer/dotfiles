
from pyinfra.operations import files, server

DOWNLOAD_DIR = "/tmp/jetbrains"

files.directory(
    name="Creating download directory",
    path=DOWNLOAD_DIR,
)

files.download(
    name="Download jetbrains toolbox archive",
    src="https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=linux",
    dest=DOWNLOAD_DIR,
)
