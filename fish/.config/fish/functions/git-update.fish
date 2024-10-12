function git-update --description '??'

    function print
        echo -e "\n#" $argv
    end

    set starting_branch (git branch --show-current)

    git fetch --tags --prune --prune-tags

    set is_dirty false
    if not git diff --quiet
        print "Workspace is dirty. Stashing changes ..."
        set is_dirty true
        git stash save "before-pulling-and-rebasing"
    end

    if git branch --list | grep -q "master"
        set main_branch "master"
    else if git branch --list | grep -q "main"
        set main_branch "main"
    else
        print "# Error: Unable to guess the default branch for this repo."
        git branch list
        return
    end

    if [ "$starting_branch" != "$main_branch" ]
        print "Switching to $main_branch ..."
        git switch $main_branch
    end

    print "Updating $main_branch ..."
    git pull origin

    if [ "$starting_branch" != "$main_branch" ]
        print "Rebasing $starting_branch onto $main_branch ..."
        git switch $starting_branch
        git rebase $main_branch
    end

    if $is_dirty
        print "Popping stash ..."
        git stash pop
    end
end
