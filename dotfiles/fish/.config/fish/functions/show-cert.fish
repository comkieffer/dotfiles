function show-cert \
  --description 'Download a certificate and display it'

  argparse 'h/help' 'c/chain' 's/short' -- $argv
  or return 1

  if set -q _flag_help
    echo "Usage: "(status function)" [OPTIONS] CERTIFICATE_OR_HOST"
    echo ""
    echo "Options:"
    echo "  -c, --chain   Show the full certificate chain"
    echo "  -s, --short   Show only the organisation (O) field of each certificate"
    echo "  -h, --help    Show this help message"
    return 0
  end

  if test (count $argv) -ne 1
    echo "Usage: "(status function)" [--chain|-c] [--short|-s] CERTIFICATE_OR_HOST"
    return 1
  end

  if test -f $argv[1]
    set output (openssl x509 -noout -text -in $argv[1])
  else
    string match --regex '^(?:https?:\/\/)?(?<openssl_host>.+)' $argv[1] >/dev/null
    if set -q _flag_chain
      set output (
        openssl s_client -connect "$openssl_host:443" -showcerts </dev/null 2>/dev/null \
          | awk '
              /-----BEGIN CERTIFICATE-----/ { cert = "" }
              { cert = cert $0 "\n" }
              /-----END CERTIFICATE-----/ {
                print cert | "openssl x509 -noout -text"
                close("openssl x509 -noout -text")
                print "---"
              }
            '
      )
    else
      set output (
        echo -n | openssl s_client -connect "$openssl_host:443" 2>/dev/null \
          | openssl x509 -noout -text
      )
    end
    if test (count $output) -eq 0
      echo (status function)": could not connect to $openssl_host" >&2
      return 1
    end
  end

  if set -q _flag_short
    set subjects (printf '%s\n' $output | grep '^\s*Subject:.*=' | string trim | string replace 'Subject: ' '')
    set last_issuer (printf '%s\n' $output | grep '^\s*Issuer:' | string trim | string replace 'Issuer: ' '' | tail -1)

    set formatted
    for s in $subjects $last_issuer
      set norm (string replace -ra ' = ' '=' -- $s)
      set cn (echo $norm | grep -oP '\bCN=\K[^,]+' | string trim)
      set rest (echo $norm | sed 's/,\? *CN=[^,]*//' | string trim --chars=', ')
      if test -n "$cn"
        if test -n "$rest"
          set formatted $formatted "$cn ($rest)"
        else
          set formatted $formatted "$cn"
        end
      else
        set formatted $formatted "$s"
      end
    end

    set i 1
    for s in $formatted
      if test $i -eq 1
        echo $s
      else
        set reps (math $i - 2)
        if test $reps -le 0
          echo "⬑ $s"
        else
          echo (string repeat -n $reps '  ')"⬑ $s"
        end
      end
      set i (math $i + 1)
    end
  else
    printf '%s\n' $output | grep -vE '^\s+([0-9a-f]{2}:){2,}[0-9a-f]{2}:?$'
  end
end
