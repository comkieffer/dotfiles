# Dotfiles Repository 

## Installation 

Download the dotfiles repository:

``` console
$ git clone URL 
$ cd dotfiles
```

Install the required dependencies

``` console 
$ installers/bootstrap.bash
```

Finally start setting up the system: 

``` console 
$ ~/local/bin/pyinfra @local installers/install-base-system.py
```

## Manual Configuration

### Sublime Text 3 

You must manually enable `PackageControl` in Sublime Text. Open the program and 
disregard all the error windows that appear for now (mostly missing theme and
colour scheme) and press `S-C-P` to open the command palette. Type start 
typining `package control` and select `Install Package Control` when the 
option appears. 

Package control will start installing all the package in the background. Once its 
finished, it will have made some changes to the Sublime-Settings (to change the theme
away from the previously missing one for example), just revert those and restart Sublime.

