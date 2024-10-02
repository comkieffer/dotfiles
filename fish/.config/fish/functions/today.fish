function today --description 'Edit the jrnl entry for _today_'
  set last_entry_date (jrnl '#daily' -1 --format dates | cut -f 1 -d ",")
  if [ $last_entry_date = (date +%F) ];
    # The last entry is for today, we can go straight to editing it.
    jrnl @daily -1 --edit
  else
    # No entry created yet. Time to create one.
    jrnl
  end
end
