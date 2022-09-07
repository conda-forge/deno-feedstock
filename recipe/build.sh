#!/usr/bin/env sh

export CARGO_BUILD_RUSTFLAGS="-C link-arg=-Wl,-rpath-link,${BUILD_PREFIX:-${CONDA_PREFIX}}/lib"
declare -x "CARGO_TARGET_${CONDA_RUST_TARGET}_RUSTFLAGS"="-C link-arg=-Wl,-rpath,${PREFIX:-${CONDA_PREFIX}}/lib"

cargo bundle-licenses --format yaml --output DENO_THIRDPARTY_LICENSES.yml
cargo build --release 

mkdir -p $PREFIX/bin
OUTPUT_EXE=$(find target -name deno | tail -n 1)
mv $OUTPUT_EXE $PREFIX/bin/deno

mkdir -p $PREFIX/etc/conda/activate.d
echo "export DENO_INSTALL_ROOT=$PREFIX" > "${PREFIX}/etc/conda/activate.d/deno.sh"

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "unset DENO_INSTALL_ROOT" > "${PREFIX}/etc/conda/deactivate.d/deno.sh"
