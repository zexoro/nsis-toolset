#!/usr/bin/env bash
# Linux x64 only: builds the Windows-side NSIS data (stubs, plug-ins, includes,
# Modern UI, language files) with mingw-w64 into $1, flat layout.
set -euo pipefail
out=$(realpath -m "$1")
cd "$(dirname "$0")/../src"

scons -j"$(nproc)" \
  XGCC_W32_PREFIX=i686-w64-mingw32- \
  NSIS_CONFIG_CONST_DATA_PATH=no \
  SKIPUTILS=all SKIPDOC=all \
  PREFIX="$out" \
  install

rm -f "$out/makensis"
cp COPYING "$out/COPYING"
