function show-cert \
  --description 'Download a certificate and display it'

  if test (count $argv) -ne 1
    echo Usage: (status function) CERTIFICATE_OR_HOST
    return 1
  end


  if test -f $argv[1]
    openssl x509 -noout -text -in $argv[1]
    return $status
  end

  # If the url has http:// or https:// strip it.
  # The `openssL_host` variable contains the rest of the string.
  string match --regex '^(?:https?:\/\/)?(?<openssl_host>.+)' $argv[1] > /dev/null;

  echo "Downloading certificate from $openssl_host ..."
  echo -n \
    | openssl s_client -connect "$openssl_host:443" 2>/dev/null \
    | openssl x509 -text
end
