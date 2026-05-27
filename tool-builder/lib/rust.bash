# Source this file; do not execute it directly.

build_with_rust() {
    detect_arch

    local rustup_home cargo_home cargo_bin
    rustup_home="$(build_dir)/rustup"
    cargo_home="$(build_dir)/cargo"
    cargo_bin="$cargo_home/bin/cargo"

    # shellcheck disable=SC1007
    local repo= version= src= out= target=

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --repo)    repo="$2";    shift 2 ;;
            --version) version="$2"; shift 2 ;;
            --src)     src="$2";     shift 2 ;;
            --out)     out="$2";     shift 2 ;;
            --target)  target="$2";  shift 2 ;;
            *) echo "Unknown flag: $1" >&2; return 1 ;;
        esac
    done

    target="${target:-${ARCH}-unknown-linux-musl}"
    src="${src:-$(src_dir "$(basename "$repo" .git)")}"
    local bin_name
    bin_name="$(basename "$out")"

    # shellcheck disable=SC2155
    export RUSTUP_HOME="$rustup_home"

    # shellcheck disable=SC2155
    export CARGO_HOME="$cargo_home"

    # cc-rs looks for <triple>-gcc for musl targets; point it to musl-gcc instead.
    # Requires musl-gcc (package msul-tools)
    if [[ "$target" == *-linux-musl ]]; then
        local target_upper
        target_upper="${target//-/_}"
        target_upper="${target_upper^^}"
        export "CARGO_TARGET_${target_upper}_LINKER=musl-gcc"
        export "CC_${target//-/_}=musl-gcc"
    fi

    echo "==> build-rust: $out (version $version, $target)"

    if [[ ! -x "$cargo_bin" ]]; then
        echo "==> Cargo not found, running install-rust"
        "$TOOL_BUILDER_DIR/lib/install-rust"
    fi

    echo "==> Ensuring target $target"
    "$cargo_home/bin/rustup" target add "$target"

    fetch_or_clone "$repo" "$version" "$src"

    echo "==> Building"
    "$cargo_bin" build \
        --manifest-path "$src/Cargo.toml" \
        --release \
        --target "$target" \
        --bin "$bin_name"

    echo "==> Copying binary"
    mkdir -p "$(dirname "$out")"
    cp "$src/target/$target/release/$bin_name" "$out"

    echo "==> Done: $(file "$out")"
}
