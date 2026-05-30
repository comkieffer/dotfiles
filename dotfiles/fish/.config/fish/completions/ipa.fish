# Completions for the ipa alias
complete -c ipa --no-files -a '(ip --json address show | jq -r '.[].ifname')'
