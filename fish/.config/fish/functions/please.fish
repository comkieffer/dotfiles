
# For when you forget to use sudo ...

function please \
    --description 'For when you forget to use sudo ...'
  commandline -i "sudo $history[1]";history delete --exact --case-sensitive please $argv;
end
