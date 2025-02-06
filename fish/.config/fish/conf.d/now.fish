# function now --description 'Add a new time tracking entry'
#   set now_file "$HOME/now.txt"
#   touch $now_file

#   if count $argv > /dev/null
#     # Add a new entry to the no file
#     set current_time (date --rfc-3339=seconds)
#     echo "- [$current_time] $argv" >> ~/now.txt
#   else
#       tail -n 10 $now_file
#   end

# end

# Give me a reminder every now and then that I need to add a prompt entry.
function preexec_now_check --on-event fish_preexec
    # Check that we are not running the now command. It's pointless to ask the user to
    # run it if that is what they are doing.
    if string match --quiet --regex "now" $argv
        return
    end

    # If we are running a script, we really don't want to have extra jank in the middle
    if status is-interactive
        now --should-update && now --prompt
    end
end
