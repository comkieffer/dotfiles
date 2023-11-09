function ipa --wraps='ip --color=auto --brief address' --description 'alias ipa ip --color=auto --brief address'
  ip --color=auto --brief address $argv; 
end
