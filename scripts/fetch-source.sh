#!/usr/bin/env bash
# Downloads the pinned NSIS source, verifies it and extracts it to ./src.
set -euo pipefail
cd "$(dirname "$0")/.."
source nsis.env

archive="nsis-${NSIS_VERSION}-src.tar.bz2"
url="https://downloads.sourceforge.net/project/nsis/NSIS%203/${NSIS_VERSION}/${archive}"

curl -fsSL --retry 5 --retry-all-errors -o "$archive" "$url"
actual=$(sha256sum "$archive" | cut -d' ' -f1)
if [[ "$actual" != "$NSIS_SHA256" ]]; then
  echo "SHA-256 mismatch for $archive: expected $NSIS_SHA256, got $actual" >&2
  exit 1
fi

rm -rf src && mkdir src
tar -xjf "$archive" -C src --strip-components=1
