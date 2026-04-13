#!/usr/bin/env bash

set -e

mkdir -p $PREFIX/bin
cp deno $PREFIX/bin/deno
chmod +x $PREFIX/bin/deno

mkdir -p $PREFIX/etc/conda/activate.d
echo "export DENO_INSTALL_ROOT=$PREFIX" > "${PREFIX}/etc/conda/activate.d/deno.sh"

mkdir -p $PREFIX/etc/conda/deactivate.d
echo "unset DENO_INSTALL_ROOT" > "${PREFIX}/etc/conda/deactivate.d/deno.sh"
