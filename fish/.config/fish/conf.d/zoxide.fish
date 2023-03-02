# Required `zoxide` package install with
#   apt install zoxide
#
# Provides the `z` command to navigate the directory tree

if type -q zoxide;
    zoxide init fish | source
end
