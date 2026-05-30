# Check if the upstream dotfiles repository is ahead.
#
# Since the dotfiles repo is often updated from multiple machines, it tends to always be
# slightly out of date. This script will show a warnibng if that is the case, to remind
# me to pull and re-stow.
#
# It only checks if the repo is up-to-date, not if I have actually run the install
# script again.

if status is-interactive
    set -l _dotfiles $HOME/dev/personal/dotfiles
    set -l _hash_file $HOME/.cache/dotfiles-origin-master-ref

    if test -f $_hash_file
        set -l last_updated_origin_head (cat $_hash_file)
        if not git -C $_dotfiles cat-file -e $last_updated_origin_head 2>/dev/null
            echo (set_color yellow)"▲"(set_color normal)" "(set_color --bold)"dotfiles:"(set_color normal)" upstream has new commits — consider pulling"
        end
    end

    fish -c "
        set hash (git -C $_dotfiles ls-remote origin refs/heads/master 2>/dev/null | cut -f1)
        if test -n \$hash
            echo \$hash > $_hash_file
        end
    " >/dev/null 2>&1 &
end
