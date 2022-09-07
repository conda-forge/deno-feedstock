#!/usr/bin/env sh

unset CARGO_BUILD_RUSTFLAGS
declare -x "CARGO_TARGET_${CONDA_RUST_HOST}_RUSTFLAGS"="-C link-arg=-Wl,-rpath,${BUILD_PREFIX}/lib,-L${BUILD_PREFIX}/lib"
declare -x "CARGO_TARGET_${CONDA_RUST_TARGET}_RUSTFLAGS"="-C link-arg=-Wl,-rpath,${PREFIX}/lib,-L${PREFIX}/lib"

export "CARGO_TARGET_${CONDA_RUST_HOST}_RUSTFLAGS"
export "CARGO_TARGET_${CONDA_RUST_TARGET}_RUSTFLAGS"

cargo bundle-licenses --format yaml --output DENO_THIRDPARTY_LICENSES.yml
cargo build --release 

mkdir -p $PREFIX/bin
OUTPUT_EXE=$(find target -name deno | tail -n 1)
mv $OUTPUT_EXE $PREFIX/bin/deno

mkdir -p $PREFIX/etc/conda/activate.d
echo "export DENO_INSTALL_ROOT=$PREFIX" > "${PREFIX}/etc/conda/activate.d/deno.sh"

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "unset DENO_INSTALL_ROOT" > "${PREFIX}/etc/conda/deactivate.d/deno.sh"
