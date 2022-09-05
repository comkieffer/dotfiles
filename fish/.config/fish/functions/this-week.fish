function this-week --wraps='jrnl -from "monday" --format=fancy' --description 'alias this-week jrnl -from "monday" --format=fancy'
  jrnl -from "monday" --format=fancy $argv; 
end
