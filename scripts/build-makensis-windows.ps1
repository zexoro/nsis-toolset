# Builds makensis.exe (x64) with MSVC into $args[0], linking zlib from vcpkg statically.
$ErrorActionPreference = 'Stop'
$out = [System.IO.Path]::GetFullPath($args[0])

& "$env:VCPKG_INSTALLATION_ROOT\vcpkg.exe" install zlib:x64-windows-static
if ($LASTEXITCODE -ne 0) { throw "vcpkg failed" }
$zlib = "$env:VCPKG_INSTALLATION_ROOT\installed\x64-windows-static"

Push-Location (Join-Path $PSScriptRoot '..\src')
try {
    scons `
        TARGET_ARCH=amd64 `
        NSIS_CONFIG_CONST_DATA_PATH=no `
        SKIPSTUBS=all SKIPPLUGINS=all SKIPUTILS=all SKIPMISC=all SKIPDOC=all `
        "ZLIB_W32=$zlib" `
        "PREFIX=$out" `
        install-compiler
    if ($LASTEXITCODE -ne 0) { throw "scons failed" }
}
finally {
    Pop-Location
}
