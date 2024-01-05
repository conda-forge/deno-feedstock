#!/bin/sh

export LD_LIBRARY_PATH="$PREFIX/lib"
exec "$@"
