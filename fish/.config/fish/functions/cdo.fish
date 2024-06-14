
function cdo --argument-names "fzf-query-path" \
  --description "Change to the selected directory and open IDE"
  if [ ! -f (cdp-cache-refresh cache-path) ]
    echo "Regenerating cache ..."
    cdp-cache-refresh refresh; or return
  end

  # Figure out what we want to open
  set --local project_dir (
    cat (cdp-cache-refresh cache-path) \
    | fzf --preview 'bat --color=always {}/README.md' \
          --header "Run 'cdp-cache-refresh refresh' to update the cache" \
          --height 40% --layout=reverse --border \
          --select-1 \
          --query "$argv" \
  )

  if not string length -q "$project_dir";
    return
  end

  set --local ide_command (which code)
  if type -q clion && [ -f $project_dir/CMakeLists.txt ]
    set  ide_command (which clion)
  else if type -q pycharm && [ -f $project_dir/pyproject.toml ]
    set ide_command (which pycharm)
  end

  # Run the command and disown it so that when we close the shell, we don't
  # close our newly opened IDE.
  $ide_command $project_dir &> /dev/null &; disown;
end
