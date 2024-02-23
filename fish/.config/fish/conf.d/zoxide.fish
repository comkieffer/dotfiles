# Required `zoxide` package install with
#   apt install zoxide
#
# Alternatively, use the install script from the repository to download the
# binary directly
#
#  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
#
# Provides the `z` command to navigate the directory tree

if status is-interactive
    if type -q zoxide;
        zoxide init fish | source
    end
end
