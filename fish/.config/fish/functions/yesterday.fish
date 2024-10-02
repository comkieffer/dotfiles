function yesterday --description 'Print jrnl entries for the last work day'


  set jrnl_flags -tagged '#daily' --format md
  set day_of_week (date "+%u")

  set entries_since "yesterday"
  if test $day_of_week = 1
    set entries_since "last friday"
  end

  set pager less
  if type -q bat
    set pager bat --language md
  end

  # jrnl will print out some status info on stderr. We don't care about it.
  jrnl -from "$entries_since" $jrnl_flags 2>/dev/null | $pager

end
