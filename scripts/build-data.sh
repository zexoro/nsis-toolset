#!/usr/bin/env bash
# Linux x64 only: builds the Windows-side NSIS data (stubs, plug-ins, includes,
# Modern UI, language files) with mingw-w64 into $1, flat layout.
set -euo pipefail
out=$(realpath -m "$1")
cd "$(dirname "$0")/../src"

scons -j"$(nproc)" \
  XGCC_W32_PREFIX=i686-w64-mingw32- \
  NSIS_CONFIG_CONST_DATA_PATH=no \
  SKIPUTILS=all SKIPDOC=all SKIPMISC=Graphics \
  PREFIX="$out" \
  install

# The source archive omits some images that Contrib/Graphics/SConscript lists,
# so copy the graphics that do exist instead of letting scons install them.
mkdir -p "$out/Contrib/Graphics"
(cd Contrib/Graphics && find . -type f ! -name SConscript -exec cp --parents {} "$out/Contrib/Graphics/" \;)

rm -f "$out/makensis"
cp COPYING "$out/COPYING"
