# Builds makensis.exe (x64) with MSVC into $args[0], linking zlib from vcpkg statically.
$ErrorActionPreference = 'Stop'
$out = [System.IO.Path]::GetFullPath($args[0])

& "$env:VCPKG_INSTALLATION_ROOT\vcpkg.exe" install zlib:x64-windows-static
if ($LASTEXITCODE -ne 0) { throw "vcpkg failed" }
$vcpkgZlib = "$env:VCPKG_INSTALLATION_ROOT\installed\x64-windows-static"

# NSIS looks for a zlib import library named zdll.lib; link the static zlib under that name.
$zlib = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\out\zlib'))
New-Item -ItemType Directory -Force "$zlib\include", "$zlib\lib" | Out-Null
Copy-Item "$vcpkgZlib\include\zlib.h", "$vcpkgZlib\include\zconf.h" "$zlib\include"
Get-ChildItem "$vcpkgZlib\lib" | Format-Table -AutoSize | Out-String | Write-Host
$staticLib = Get-ChildItem "$vcpkgZlib\lib\*.lib" | Select-Object -First 1
if (-not $staticLib) { throw "no zlib static library under $vcpkgZlib\lib" }
Copy-Item $staticLib.FullName "$zlib\lib\zdll.lib"

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

    # Same layout as the POSIX builds: makensis at the archive root, next to Stubs/.
    Move-Item (Join-Path $out 'Bin\makensis.exe') (Join-Path $out 'makensis.exe') -Force
    Remove-Item (Join-Path $out 'Bin') -Recurse -Force
}
finally {
    Pop-Location
}
