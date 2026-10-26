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

`SHA256SUMS` lists the hash of every archive.

## License

The build scripts in this repository are under the [MIT license](LICENSE). The archives contain NSIS, which is under its own licenses (zlib/libpng, with parts under bzip2 and CPL terms); each archive includes NSIS's `COPYING` file.
