function digg --wraps='dig +noall +answer' \
  --description 'Dig without the fluff'
  dig +noall +answer $argv;
end
