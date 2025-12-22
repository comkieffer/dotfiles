function zq --description "Interactively query zoxide with fzf and cd to selected directory"
  # Get zoxide query results based on arguments, or list all if no args
  set --local query_results
  if test (count $argv) -gt 0
    set query_results (zoxide query --list $argv)
  else
    set query_results (zoxide query --list)
  end

  # Check if we got any results
  if not string length -q "$query_results"
    echo "No directories found"
    return 1
  end

  # If only one result, jump straight to it
  set --local result_count (printf '%s\n' $query_results | count)
  if test $result_count -eq 1
    cd "$query_results"
    return
  end

  # Use fzf to select a directory with tree preview
  set --local selected_dir (
    printf '%s\n' $query_results \
    | fzf --preview 'tree -C -L 2 {}' \
          --preview-window 'right:50%' \
          --height 40% \
          --layout reverse \
          --border \
          --prompt 'zoxide> ' \
          --header 'Select directory to cd into'
  )

  # If a directory was selected, cd to it
  if string length -q "$selected_dir"
    cd "$selected_dir"
  end
end
