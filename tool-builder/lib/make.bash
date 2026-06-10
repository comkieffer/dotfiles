# Source this file; do not execute it directly.

build_with_make() {
    # shellcheck disable=SC1007
    local src= out= prefix= make_target=install

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --src)         src="$2";         shift 2 ;;
            --out)         out="$2";         shift 2 ;;
            --prefix)      prefix="$2";      shift 2 ;;
            --make-target) make_target="$2"; shift 2 ;;
            *) echo "Unknown flag: $1" >&2; return 1 ;;
        esac
    done

    if ! command -v make &>/dev/null; then
        echo "==> make command not found, cannot continue."
        return 1
    fi

    if [[ ! -f "$src/configure" && -f "$src/configure.ac" ]]; then
        echo "==> running autoreconf"
        autoreconf -i "$src"
    fi

    if [ -f "$src/configure" ]; then
        echo "==> executing configure script"
        if [[ -n "$prefix" ]]; then
            (cd "$src" && ./configure --prefix="$prefix")
        else
            (cd "$src" && ./configure)
        fi
    fi

    echo "==> executing make"
    make -C "$src" "$make_target"

    echo "==> Done: $(file "$out")"
}
