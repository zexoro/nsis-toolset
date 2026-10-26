#!/usr/bin/env bash
# Linux x64 only: builds the Windows-side NSIS data (stubs, plug-ins, includes,
# Modern UI, language files) with mingw-w64 into $1, flat layout.
set -euo pipefail
out=$(realpath -m "$1")
cd "$(dirname "$0")/../src"

# Serial on purpose: with -j, installing the misc data fails with
# "No such file or directory" for files that exist in the source tree.
scons \
  XGCC_W32_PREFIX=i686-w64-mingw32- \
  NSIS_CONFIG_CONST_DATA_PATH=no \
  SKIPUTILS=all SKIPDOC=all \
  PREFIX="$out" \
  install

rm -f "$out/makensis"
cp COPYING "$out/COPYING"
