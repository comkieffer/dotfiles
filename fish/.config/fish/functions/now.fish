function now --description 'Add a new time tracking entry'
  set now_file "$HOME/now.txt"
  touch $now_file

  if count $argv > /dev/null
    # Add a new entry to the no file
    set current_time (date --rfc-3339=seconds)
    echo "- [$current_time] $argv" >> ~/now.txt
  else
      tail -n 10 $now_file
  end


end
