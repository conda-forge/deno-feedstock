#!/usr/bin/env bash

set -e

mkdir -p $PREFIX/bin

# bundle licenses
cargo-bundle-licenses --format yaml --output DENO_THIRDPARTY_LICENSES.yml

# set up activate/deactivate script
mkdir -p $PREFIX/etc/conda/activate.d
echo "export DENO_INSTALL_ROOT=$PREFIX" > "${PREFIX}/etc/conda/activate.d/deno.sh"

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "unset DENO_INSTALL_ROOT" > "${PREFIX}/etc/conda/deactivate.d/deno.sh"

if [ -x target/prebuilt/deno ]; then
    echo "Copying prebuilt binary"
    cp target/prebuilt/deno "$PREFIX/bin"
else
    if [[ "$SUBDIR" =~ ^osx.* ]]; then
        if [ "$SUBDIR" = "osx-x64" ]; then
            export CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER=$CC
            # cargo build --target x86_64-apple-darwin --release
        else
            export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER=$CC
            # cargo build --target aarch64-apple-darwin --release
        fi
    fi

    # turn down LTO for all builds, it takes forever
    export CARGO_PROFILE_RELEASE_LTO=thin

    build_args=
    if [[ "$CONDA_TOOLCHAIN_BUILD" != "$CONDA_TOOLCHAIN_HOST" ]]; then
        echo "Cross-compiling for target $CARGO_BUILD_TARGET" >&2
        # echo "Building patched cargo" >&2
        # (cd cargo-cross && cargo build --release --features all-static --target x86_64-unknown-linux-gnu)
        # CARGO="$PWD/cargo-cross/target/x86_64-unknown-linux-gnu/release/cargo"

        # we know what we're doing lol
        export DENO_SKIP_CROSS_BUILD_CHECK=1
        # this var screws up libffi builds, we need both build & host builds
        unset host_alias

        # # set up the cross-build things
        # export CARGO_CROSS_BUILD_CRATES=deno_runtime:deno
        # export CARGO_CROSS_BUILD_RS=deno_runtime/build.rs:deno/build.rs
        # export CARGO_CROSS_BUILD_RUN="$RECIPE_DIR/cross-run.sh"
        # the hot module reloading feature gets Deno working without snapshots.
        build_args="--target $CARGO_BUILD_TARGET --features hmr"
    else
        CARGO=cargo
    fi

    CARGO=cargo
    echo "$CARGO build --release -v $build_args" >&2
    $CARGO build --release -v $build_args

    mkdir -p $PREFIX/bin
    OUTPUT_EXE=$(find target -name deno | tail -n 1)
    mv $OUTPUT_EXE $PREFIX/bin/deno

    echo "cleaning cargo dir"
    [ -n "$CARGO_HOME" ] && rm -rf "$CARGO_HOME"
fi
