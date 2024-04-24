function yesterday --description 'Print jrnl entries for the last day'
  set jrnl_flags --format md
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
  jrnl -from "$entries_since" -tagged @daily $jrnl_flags $argv 2>/dev/null | $pager
end
