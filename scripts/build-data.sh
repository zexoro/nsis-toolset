#!/usr/bin/env bash
# Linux x64 only: builds the Windows-side NSIS data (stubs, plug-ins, includes,
# Modern UI and its UIs/*.exe templates, language files) with mingw-w64 into $1, flat layout.
set -euo pipefail
out=$(realpath -m "$1")
source "$(dirname "$0")/../nsis.env"
version_args=(VERSION="$NSIS_VERSION" VER_MAJOR="${NSIS_VERSION%%.*}" VER_MINOR="${NSIS_VERSION#*.}")
cd "$(dirname "$0")/../src"

# Serial on purpose: with -j, installing the misc data fails with
# "No such file or directory" for files that exist in the source tree.
scons \
  XGCC_W32_PREFIX=i686-w64-mingw32- \
  NSIS_CONFIG_CONST_DATA_PATH=no \
  "SKIPUTILS=Library/RegTool,MakeLangId,Makensisw,NSIS Menu,SubStart,VPatch/Source/GenPat,zip2exe" \
  SKIPDOC=all \
  "${version_args[@]}" \
  PREFIX="$out" \
  install

rm -f "$out/makensis"
cp COPYING "$out/COPYING"
