
function cdp --argument-names "fzf-query-path" \
  --description "Change to the selected directory"
  if [ ! -f (cdp-cache-refresh cache-path) ]
    echo "Regenerating cache ..."
    cdp-cache-refresh refresh
  end

  cd (
    cat (cdp-cache-refresh cache-path) \
      | fzf --preview 'bat --color=always {}/README.md' \
            --height 40% --layout=reverse --border \
            --query "$argv" \
  )
end
