#!/usr/bin/env sh

cargo bundle-licenses --format yaml --output DENO_THIRDPARTY_LICENSES.yml
if [[ "$SUBDIR" =~ ^osx.* ]]; then
    # requires special treatment because we need the Metal framework.
    if [ "$SUBDIR" = "osx-x64" ]; then
        cargo build --target x86_64-apple-darwin --release
    else
        cargo build --target aarch64-apple-darwin --release
    fi
else
    cargo build --release
fi

mkdir -p $PREFIX/bin
OUTPUT_EXE=$(find target -name deno | tail -n 1)
mv $OUTPUT_EXE $PREFIX/bin/deno

mkdir -p $PREFIX/etc/conda/activate.d
echo "export DENO_INSTALL_ROOT=$PREFIX" > "${PREFIX}/etc/conda/activate.d/deno.sh"

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "unset DENO_INSTALL_ROOT" > "${PREFIX}/etc/conda/deactivate.d/deno.sh"
