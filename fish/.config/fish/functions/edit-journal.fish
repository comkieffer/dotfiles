function edit-journal --wraps='vim ~/Documents/journal.txt -c ":set syntax=markdown"' --description 'alias edit-journal vim ~/Documents/journal.txt -c ":set syntax=markdown"'
  vim ~/Documents/journal.txt -c ":set syntax=markdown" $argv; 
end
