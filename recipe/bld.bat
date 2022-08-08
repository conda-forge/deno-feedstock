
cargo bundle-licenses --format yaml --output DENO_THIRDPARTY_LICENSES.yml
cargo build --release
mkdir %LIBRARY_BIN%
COPY target\release\deno.exe %LIBRARY_BIN%\deno.exe

mkdir %PREFIX:/=\%\etc\conda\activate.d
echo SET "DENO_INSTALL_ROOT=%LIBRARY_PREFIX:/=\%" > "%PREFIX:/=\%\etc\conda\activate.d\deno.bat"

mkdir %PREFIX:/=\%\etc\conda\deactivate.d
echo SET "DENO_INSTALL_ROOT=" > "%PREFIX:/=\%\etc\conda\deactivate.d\deno.bat"
