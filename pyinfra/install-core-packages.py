from pyinfra.operations import apt

apt.update(name="Update apt repositories", cache_time=3600)

apt.packages(
	name="Install core tools",
	packages=[
		"htop",
		"stow",
		"fish"
	],
	no_recommends=True,
)

apt.packages(
	name="Install core development tools",
	packages=[
		"git",
		"git-absorb"
	],
	no_recommends=True,
)

apt.packages(
	name="Install C & C++ development tools",
	packages=[
		"build-essential",
		"cmake",
		"cmake-qt-gui",
	],
	no_recommends=True,
)

apt.packages(
	name="Install system administration tools",
	packages=[
		"nmap"
	],
	no_recommends=True,
)

apt.packages(
	name="Install modern command line tools",
	packages=[
		"bat",
		"dtrx",
		"eza",
		"fd-find",
		"fzf",
		"jq",
		"ripgrep",
		"trash-cli",
		"wifi-qr",
	],
	no_recommends=True,
)
