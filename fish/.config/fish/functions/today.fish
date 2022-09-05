function today --wraps='jrnl -on today --format fancy' --description 'alias today jrnl -on today --format fancy'
  jrnl -on today --format fancy $argv; 
end
