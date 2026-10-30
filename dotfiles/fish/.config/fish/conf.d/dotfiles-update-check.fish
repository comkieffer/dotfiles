# Check if the upstream dotfiles repository is ahead.
#
# Since the dotfiles repo is often updated from multiple machines, it tends
# to always be slightly out of date. This script will show a warning if that
# is the case, to remind me to pull and re-stow.
#
# It only checks if the repo is up-to-date, not if I have actually run the
# install script again.

function has-unpulled-commits --argument-names repo upstream_head
    not git -C $repo merge-base --is-ancestor $upstream_head HEAD 2>/dev/null
end

function recent-commit-titles --argument-names repo upstream_head
    git -C $repo log \
        --format=%s \
        --max-count=5 \
        HEAD..$upstream_head 2>/dev/null
end

function fetch-repository --description 'Fetch the dotfiles repository'
    set -l repo $HOME/dev/personal/dotfiles
    set -l ref_file $HOME/.cache/dotfiles-origin-master-ref
    set -l remote_head (git -C $repo ls-remote \
        origin refs/heads/master 2>/dev/null | cut -f1)

    if test -z "$remote_head"
        return
    end

    if not git -C $repo cat-file -e $remote_head 2>/dev/null
        git -C $repo fetch --quiet --no-tags origin master 2>/dev/null
    end

    if git -C $repo cat-file -e $remote_head 2>/dev/null
        echo $remote_head >$ref_file
    end
end

if status is-interactive
    set -l _dotfiles $HOME/dev/personal/dotfiles
    set -l _hash_file $HOME/.cache/dotfiles-origin-master-ref

    if test -f $_hash_file
        set -l last_updated_origin_head (cat $_hash_file 2>/dev/null)
        if test -n "$last_updated_origin_head"
            if has-unpulled-commits $_dotfiles $last_updated_origin_head
                printf '%s%s%s%s%s\n' \
                    (set_color yellow)"▲" \
                    (set_color normal)" " \
                    (set_color --bold)"dotfiles:" \
                    (set_color normal)" " \
                    "upstream has new commits — consider pulling"

                set -l _titles (recent-commit-titles \
                    $_dotfiles $last_updated_origin_head)
                for title in $_titles
                    echo "  $title"
                end
            end
        end
    end

    fish -c fetch-repository 2>&1 &
end
