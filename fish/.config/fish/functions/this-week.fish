function this-week --wraps='jrnl -from "monday" --format=fancy' --description 'alias this-week jrnl -from "monday" --format=fancy'
  set jrnl_flags --format md
  set day_of_week (date "+%u")

  set entries_since "monday"
  if test $day_of_week = 1
    set entries_since "last monday"
  end

  set pager less
  if type -q bat
    set pager bat --language md
  end

  jrnl -from "$entries_since" -tagged @daily $jrnl_flags $argv | $pager
end
