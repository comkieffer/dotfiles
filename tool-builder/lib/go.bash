# Source this file; do not execute it directly.

build_with_go() {
    # shellcheck disable=SC1007
    local src= out= ldflags=

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --src)     src="$2";     shift 2 ;;
            --out)     out="$2";     shift 2 ;;
            --ldflags) ldflags="$2"; shift 2 ;;
            *) echo "Unknown flag: $1" >&2; return 1 ;;
        esac
    done

    local go_bin
    go_bin="$(build_dir)/go/bin/go"

    echo "==> build-go: $out"

    if [[ ! -x "$go_bin" ]]; then
        echo "==> Go not found, running install-go"
        "$TOOL_BUILDER_DIR/lib/install-go"
    fi

    echo "==> Building"
    mkdir -p "$(dirname "$out")"
    CGO_ENABLED=0 "$go_bin" build \
        -C "$src" \
        -trimpath \
        -ldflags="-s -w $ldflags" \
        -o "$out" \
        .

    echo "==> Done: $(file "$out")"
}
