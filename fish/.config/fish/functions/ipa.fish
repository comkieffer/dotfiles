function ipa --wraps='ip --color=auto --brief address' --description 'alias ipa ip --color=auto --brief address'
  # Show the IP addresses for configured devices
  # --brief   : only print basic information in a tabular format
  # --resolve : use the DNS resolver to print DNS names instead of host addresses

  if test (count $argv) -gt 0;
    set -p argv "dev"
  end

  ip --color=auto --brief address show $argv;
end
