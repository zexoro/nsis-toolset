#!/usr/bin/env bash
# Builds makensis for the current POSIX host into $1. Extra arguments are
# passed to scons (e.g. APPEND_CCFLAGS for a universal macOS build).
set -euo pipefail
out=$(python3 -c 'import os,sys; print(os.path.abspath(sys.argv[1]))' "$1")
shift
cd "$(dirname "$0")/../src"

scons \
  NSIS_CONFIG_CONST_DATA_PATH=no \
  SKIPSTUBS=all SKIPPLUGINS=all SKIPUTILS=all SKIPMISC=all SKIPDOC=all \
  PREFIX="$out" \
  "$@" \
  install-compiler
