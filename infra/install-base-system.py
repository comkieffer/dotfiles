from pyinfra.operations import apt

USE_SUDO_PASSWORD=True

apt.packages(
    name="Install Packages / Bedrock",
    packages=["apt-transport-https", "wget"],
    latest=True, sudo=True,
)

apt.packages(
    name="Install Packages / Common",
    packages=["build-essential", "git", "htop", "direnv", "font-firacode"],
    latest=True, sudo=True,
)

#
# Install Sublime Text 3 + Sublime Merge
#

apt.key(
    name="Install Packages / Sublime Text 3 / Add GPG Key",
    src="https://download.sublimetext.com/sublimehq-pub.gpg",
    sudo=True,
)

apt.repo(
    name="Install Packages / Sublime Text 3 / Add Repo",
    src="deb https://download.sublimetext.com/ apt/stable/",
    filename="sublime-text",
    sudo=True,
)

apt.packages(
    name="Install Packages / Sublime Text 3 / Install Package",
    packages=["sublime-text", "sublime-merge"],
    sudo=True, update=True,
)

#
# Install FMan
# 

apt.key(
    name="Install Packages / FMan / Add GPG Key",
    keyserver="keyserver.ubuntu.com",
    keyid="9CFAF7EB", sudo=True,
)

apt.repo(
    name="Install Packages / FMan / Add Repo",
    src="deb [arch=amd64] https://fman.io/updates/ubuntu/ stable main",
    filename="fman",
    sudo=True,
)

apt.packages(
    name="Install Packages / FMan / Install Package",
    packages=["fman"],
    sudo=True, update=True,
)

#
# Install Etcher 
#

apt.key(
    name="Install Packages / Etcher / Add GPG Key",
    keyserver="keyserver.ubuntu.com",
    keyid="379CE192D401AB61", sudo=True,
)

apt.repo(
    name="Install Packages / Etcher / Add Repo",
    src="deb https://deb.etcher.io stable etcher",
    filename="balena-etcher",
    sudo=True,
)

apt.packages(
    name="Install Packages / Etcher / Install Package",
    packages=["balena-etcher-electron"],
    sudo=True, update=True,
)

#
# Install Spotify
# 

apt.key(
    name="Install Packages / Spotify / Add GPG Key",
    src="https://download.spotify.com/debian/pubkey.gpg",
    sudo=True,
)

apt.key(
    name="Install Packages / Spotify / Add GPG Key",
    src="https://download.spotify.com/debian/pubkey_0D811D58.gpg",
    sudo=True,
)

apt.repo(
    name="Install Packages / Spotify / Add Repo",
    src="deb http://repository.spotify.com stable non-fre",
    filename="spotify",
    sudo=True,
)

apt.packages(
    name="Install Packages / Spotify / Install Package",
    packages=["spotify-client"],
    sudo=True, update=True,
)

#
# Install fzf
#

git.repo(
    name='Install Tools / Fzf / Clone Repository',
    src='https://github.com/junegunn/fzf.git',
    dest='~/.local/bin/fzf',
)
