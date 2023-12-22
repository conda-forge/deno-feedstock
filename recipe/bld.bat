
cargo bundle-licenses --format yaml --output DENO_THIRDPARTY_LICENSES.yml
if errorlevel 1 exit 1
rem turn down LTO to try to avoid OOM
set CARGO_PROFILE_RELEASE_LTO=thin
echo Building Deno binary
cargo build --release --no-default-features
if errorlevel 1 exit 1

mkdir %LIBRARY_BIN%
COPY target\%HOST%\release\deno.exe %LIBRARY_BIN%\deno.exe
if errorlevel 1 exit 1

echo Cleaning %CARGO_HOME%
rd %CARGO_HOME% /s

mkdir %PREFIX:/=\%\etc\conda\activate.d
echo SET "DENO_INSTALL_ROOT=%LIBRARY_PREFIX:/=\%" > "%PREFIX:/=\%\etc\conda\activate.d\deno.bat"

mkdir %PREFIX:/=\%\etc\conda\deactivate.d
echo SET "DENO_INSTALL_ROOT=" > "%PREFIX:/=\%\etc\conda\deactivate.d\deno.bat"
