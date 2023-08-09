@echo on

if "%ARCH%"=="32" (
    set OSSL_CONFIGURE=VC-WIN32
) ELSE if "%ARCH%"=="arm64" (
    set OSSL_CONFIGURE=VC-WIN64-ARM
) ELSE (
    set OSSL_CONFIGURE=VC-WIN64A
)

REM Configure step
perl configure %OSSL_CONFIGURE%   ^
    --prefix=%LIBRARY_PREFIX%     ^
    --openssldir=%LIBRARY_PREFIX% ^
    enable-legacy                 ^
    no-fips                       ^
    no-module                     ^
    no-zlib                       ^
    shared
if %ERRORLEVEL% neq 0 exit 1

REM specify in metadata where the packaging is coming from
set "OPENSSL_VERSION_BUILD_METADATA=+conda_forge"

REM Build step
nmake
if %ERRORLEVEL% neq 0 exit 1

if NOT "%ARCH%"=="arm64" (
    REM Testing step
    nmake test
    if %ERRORLEVEL% neq 0 exit 1
)
