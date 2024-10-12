function show-cert \
  --description 'Download a certificate and display it'

  # If the url has http:// or https:// strip it.
  # The `openssL_host` variable contains the rest of the string.
  string match --regex '^(?:https?:\/\/)?(?<openssl_host>.+)' $argv > /dev/null;

  echo "Downloading certificate from $openssl_host ..."
  echo -n \
    | openssl s_client -connect "$openssl_host:443" 2>/dev/null \
    | openssl x509 -text
end
