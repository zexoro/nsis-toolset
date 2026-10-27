#!/bin/sh
# Builds a fully static, musl-linked Linux makensis into $1/Bin. Meant to run as root
# inside an Alpine container with the repository mounted as the working directory
# (see the makensis job in .github/workflows/build.yml); needs ./src already fetched.
set -eu
out=$1
apk add --no-cache bash build-base python3 scons zlib-dev zlib-static
scripts/build-makensis-posix.sh "$out" \
  "APPEND_LINKFLAGS=-static -static-libstdc++ -static-libgcc"
# The container runs as root; hand the results back to the host user.
if [ -n "${HOST_UID:-}" ]; then chown -R "$HOST_UID:${HOST_GID:-$HOST_UID}" "$out" src; fi
