
function cdp --argument-names "fzf-query-path" \
  --description "Change to the selected directory"
  if [ ! -f (cdp-cache-refresh cache-path) ]
    echo "Regenerating cache ..."
    cdp-cache-refresh refresh
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

  cd "$project_dir"
end
