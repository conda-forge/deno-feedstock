#!/usr/bin/env bash

set -e

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

    build_args=
    if [[ "$CONDA_TOOLCHAIN_BUILD" != "$CONDA_TOOLCHAIN_HOST" ]]; then
        echo "Building for target $CARGO_BUILD_TARGET" >&2
        build_args="--target=$CARGO_BUILD_TARGET --features __runtime_js_sources"
        # we know what we're doing lol
        export DENO_SKIP_CROSS_BUILD_CHECK=1
        # this var screws up libffi builds, we need both build & host builds
        unset host_alias
        # for cross-builds turn down LTO, it takes forever
        export CARGO_PROFILE_RELEASE_LTO=thin
    else
        build_args="--features snapshot"
    fi
    echo "cargo build --release $build_args" >&2
    cargo build --release $build_args

    mkdir -p $PREFIX/bin
    OUTPUT_EXE=$(find target -name deno | tail -n 1)
    mv $OUTPUT_EXE $PREFIX/bin/deno
fi

mkdir -p $PREFIX/etc/conda/activate.d
echo "export DENO_INSTALL_ROOT=$PREFIX" > "${PREFIX}/etc/conda/activate.d/deno.sh"

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "unset DENO_INSTALL_ROOT" > "${PREFIX}/etc/conda/deactivate.d/deno.sh"
