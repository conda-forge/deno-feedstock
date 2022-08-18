#!/usr/bin/env sh

mkdir -p $PREFIX/bin
if [ "$SUBDIR" = "osx-arm64" ]; then
    mv deno $PREFIX/bin
else

    cargo bundle-licenses --format yaml --output DENO_THIRDPARTY_LICENSES.yml
    if [[ "$SUBDIR" =~ ^osx.* ]]; then
        if [ "$SUBDIR" = "osx-x64" ]; then
            export CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER=$CC
            # cargo build --target x86_64-apple-darwin --release
        else
            export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER=$CC
            # cargo build --target aarch64-apple-darwin --release
        fi
    fi

    cargo build --release

    mkdir -p $PREFIX/bin
    OUTPUT_EXE=$(find target -name deno | tail -n 1)
    mv $OUTPUT_EXE $PREFIX/bin/deno
fi

mkdir -p $PREFIX/etc/conda/activate.d
echo "export DENO_INSTALL_ROOT=$PREFIX" > "${PREFIX}/etc/conda/activate.d/deno.sh"

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "unset DENO_INSTALL_ROOT" > "${PREFIX}/etc/conda/deactivate.d/deno.sh"
