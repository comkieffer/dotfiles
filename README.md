# Dotfiles Repository

Configuration files for my Linux systen(s). Tools

## Installation

Run the bootstrap script to install the required dependencies

```console
./bootstrap
```

This will run the installers to set up the system. Future runs, can use the commands in the `justfile` directly.

To actually install the dotfiles for a specific tool, use `./install`.

## Tool Setup

### Dotfiles / Dot

The `dot` command is an alias around the `dotfiles` git repository which stores
changes to the home directory. Use it as you would normally use git.

### Fish

Fish is configured to use [fisher](https://github.com/jorgebucaran/fisher) for package management. Run `fisher update` to update the installed plugins.

#### edc/bass

Run `bash` scripts that change the environment and propagate the results to `fish`. It uses a pythoon script to compare the environment before and after the script was run and applies the changes to the `fish` environment.

A simpler version is to run `bash -c script; exec fish`.

#### patrickf1/fzf.fish@v9.7

Fzf.fish is pinned to version `v9.7` because Ubuntu 22.04 only has fish 3.3 and subsequent releases require 3.4.

- `Ctrl` + `Alt` + `F` (`F` for File) - Search directory
- `Ctrl` + `Alt` + `L` (`L` for Log) - Search git log
- `Ctrl` + `Alt` + `S` (`S` for Status) - Search git status
- `Ctrl` + `Alt` + `H` (`H` for History) - Search history
- `Ctrl` + `Alt` + `P` (`P` for Processes) - Search processes
- `Ctrl` + `Alt` + `V` (`F` for Variables) - Search environment variables

#### oakninja/makemefish

Makefile browser. Uses `fzf` to show rules in the makefile.

#### gazorby/fish-abbreviation-tips

Show a warning when a command is used instead of an alias/abbreviation in fish.

#### cdo / cdp

Run `cdp-cache-refresh refresh` to refresh the projects cache.

### Regolith Session

To better understand the regolith session, look at:

- /usr/bin/regolith-session-wayland
- /usr/lib/regolith/regolith-session-common.sh

## Manual Configuration

### Sublime Text 3

You must manually enable `PackageControl` in Sublime Text. Open the program and disregard all the error windows that appear for now (mostly missing theme and colour scheme) and press `S-C-P` to open the command palette. Type start typing `package control` and select `Install Package Control` when the option appears.

Package control will start installing all the package in the background. Once its finished, it will have made some changes to the Sublime-Settings (to change the theme away from the previously missing one for example), just revert those and restart Sublime.

## Modern replacements for old tools

- `bat`: better `cat` (better `less` really)
- `exa`: better `ls`
- `rg`: better `grep`
- `fd`: better `find`
- `procs`: better `ps`
- `tokei`: better `cloc`
- `zoxide`: smarter `cd` [GitHub](https://github.com/ajeetdsouza/zoxide)
