function yesterday --description 'Print jrnl entries for the last day'
  set jrnl_flags --format fancy
  set day_of_week (date "+%u")

  set entries_since "yesterday"
  if test $day_of_week = 1
    set entries_since "last friday"
  end

  jrnl -from "$entries_since" $jrnl_flags $argv;
end
