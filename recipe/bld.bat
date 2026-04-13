MKDIR %LIBRARY_BIN%
COPY deno.exe %LIBRARY_BIN%\deno.exe
if errorlevel 1 exit 1

mkdir %PREFIX:/=\%\etc\conda\activate.d
echo SET "DENO_INSTALL_ROOT=%LIBRARY_PREFIX:/=\%" > "%PREFIX:/=\%\etc\conda\activate.d\deno.bat"

mkdir %PREFIX:/=\%\etc\conda\deactivate.d
echo SET "DENO_INSTALL_ROOT=" > "%PREFIX:/=\%\etc\conda\deactivate.d\deno.bat"
