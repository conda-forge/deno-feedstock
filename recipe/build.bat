@echo on
@setlocal EnableDelayedExpansion

set CMAKE_POLICY_VERSION_MINIMUM=3.5
set RUSTFLAGS=-C target-feature=-crt-static

:: check licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml || goto :error

:: build with Deno's upstream release-lite profile (thin LTO, codegen-units=128)
:: to avoid rustc-LLVM OOM during final link on hosted Windows runners.
cargo install --profile release-lite --no-default-features --bins --no-track --locked --root "%LIBRARY_PREFIX%" --path .\cli || goto :error

mkdir %PREFIX:/=\%\etc\conda\activate.d
echo SET "DENO_INSTALL_ROOT=%LIBRARY_PREFIX:/=\%" > "%PREFIX:/=\%\etc\conda\activate.d\deno.bat"

mkdir %PREFIX:/=\%\etc\conda\deactivate.d
echo SET "DENO_INSTALL_ROOT=" > "%PREFIX:/=\%\etc\conda\deactivate.d\deno.bat"

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
