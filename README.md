# nsis-toolset

Builds the [NSIS](https://nsis.sourceforge.io/) toolset that [zexoro](https://github.com/zexoro/zexoro) ships, from source.

> **Status:** early development.

Each release contains one archive per host platform with `makensis` and the NSIS data it needs (stubs, plug-ins, include files, Modern UI):

| Archive | Host |
| --- | --- |
| `nsis-<version>-linux-x64.tar.gz` | Linux x64 |
| `nsis-<version>-linux-arm64.tar.gz` | Linux arm64 |
| `nsis-<version>-osx.tar.gz` | macOS (universal: x64 and arm64) |
| `nsis-<version>-win-x64.tar.gz` | Windows x64 |

The Linux archives hold a fully static `makensis` linked against musl (built in an Alpine container), so it runs on any Linux distribution, glibc or musl (Alpine included), with no minimum glibc version.

`SHA256SUMS` lists the hash of every archive.

## Patches

`scripts/fetch-source.sh` verifies the pinned NSIS source archive and then applies every `patches/*.patch` in order (the rationale is in each patch header):

| Patch | Purpose |
| --- | --- |
| `0001-iconv-wchar_t-locale-independent.patch` | Stock NSIS 3.13 aborts with `std::bad_alloc` on macOS when the locale is `C`/`POSIX` (for example `LC_ALL=C` or no `LANG`), because libiconv's `wchar_t` encoding follows the process locale. The patch uses the explicit UCS-4 encoding instead, so `makensis` behaves the same in every locale. |

## Static Linux build and code pages

CI compiles a Modern UI 2 script for every language in `Contrib/Language files` with the static `makensis` (`tests/languages.sh`), in Unicode and in ANSI mode, on Ubuntu and inside a plain Alpine container. Unicode mode must pass for every language. musl's `iconv` supports fewer legacy code pages than glibc, so ANSI (`Unicode false`) installers may fail for some languages with the Linux archives; zexoro only builds Unicode installers, so this does not affect it. Failures in ANSI mode are reported in the CI log but do not fail the build.

## License

The build scripts in this repository are under the [MIT license](LICENSE). The archives contain NSIS, which is under its own licenses (zlib/libpng, with parts under bzip2 and CPL terms); each archive includes NSIS's `COPYING` file.
