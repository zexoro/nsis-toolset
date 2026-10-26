#!/usr/bin/env bash
# Linux x64 only: builds the Windows-side NSIS data (stubs, plug-ins, includes,
# Modern UI, language files) with mingw-w64 into $1, flat layout.
set -euo pipefail
out=$(realpath -m "$1")
cd "$(dirname "$0")/../src"

# Serial build: parallel installs of the misc data were seen failing with
# "No such file or directory" for files that exist in the source tree.
ls "Contrib/Language files" | head -3
scons \
  XGCC_W32_PREFIX=i686-w64-mingw32- \
  NSIS_CONFIG_CONST_DATA_PATH=no \
  SKIPUTILS=all SKIPDOC=all \
  PREFIX="$out" \
  install

rm -f "$out/makensis"
cp COPYING "$out/COPYING"
