#!/usr/bin/env bash
# Compiles a MUI2 script for every language in "Contrib/Language files", once in
# Unicode mode and once in ANSI mode, using the makensis given as $1. Prints one
# line per failure plus a summary. Exits non-zero only when a Unicode compile
# fails: ANSI code pages depend on the platform's iconv (musl supports fewer than
# glibc), and zexoro only builds Unicode installers.
set -uo pipefail
makensis=$1
nsisdir=$(dirname "$(dirname "$makensis")")
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
unicode_failed=0
for mode in true false; do
  target=x86-unicode; [[ $mode == false ]] && target=x86-ansi
  total=0; failed=()
  for f in "$nsisdir/Contrib/Language files/"*.nsh; do
    lang=$(basename "$f" .nsh)
    total=$((total + 1))
    cat > "$work/t.nsi" <<NSI
Unicode $mode
Target $target
SetCompressor zlib
RequestExecutionLevel user
!include "MUI2.nsh"
Name "T"
OutFile "$work/t.exe"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "$lang"
Section
SectionEnd
NSI
    rm -f "$work/t.exe"
    if ! "$makensis" -V1 "$work/t.nsi" > "$work/log" 2>&1 || [[ ! -s "$work/t.exe" ]]; then
      failed+=("$lang")
      echo "FAIL [Unicode $mode] $lang: $(grep -m1 -i 'error\|invalid\|iconv' "$work/log" || tail -n1 "$work/log")"
    fi
  done
  echo "Unicode $mode: $((total - ${#failed[@]}))/$total languages compiled; failed: ${failed[*]:-none}"
  [[ $mode == true && ${#failed[@]} -gt 0 ]] && unicode_failed=1
done
exit $unicode_failed
