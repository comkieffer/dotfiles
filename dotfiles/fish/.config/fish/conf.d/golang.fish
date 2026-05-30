
# If go is installed, point $GOBIN to a useful directory ...
# This makes go install binaries here instead of into ~/go/bin which is not
# on the system PATH.

if type -q go;
    set -gx GOBIN ~/.local/bin
end
