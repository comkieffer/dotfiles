function show-cert \
  --description 'Download a certificate and display it'

  # If the url has http:// or https:// strip it.
  # The `openssl_host` variable contains the rest of the string.
  string match --regex '^(?:https?:\/\/)?(?<openssl_host>.+)' $argv > /dev/null;

  # Add default port if none specified.
  if not string match --quiet --regex ':\d+$' $openssl_host
    set openssl_host "$openssl_host:443"
  end

  echo "Downloading certificate from $openssl_host ..."
  set -l cert_text (echo -n \
    | openssl s_client -connect "$openssl_host" 2>/dev/null \
    | openssl x509 -text)

  if command -q bat
    echo "$cert_text" | bat --language=yaml --plain
  else
    echo "$cert_text" | less
  end
end
