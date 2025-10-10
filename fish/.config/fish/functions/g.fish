function g --wraps='git' --description="run either `git <argv>` or `git status`"
  if test 0 -eq (count $argv); git status --short --branch
  else; git $argv
  end
end