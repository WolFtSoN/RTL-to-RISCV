@echo off
setlocal enabledelayedexpansion

set "target_folder="
set "wave_option="

:: Parse arguments robustly
for %%A in (%*) do (
    if /I "%%~A"=="-wave" (
        set "wave_option=-wave"
    ) else (
        set "target_folder=%%~A"
    )
)

if not defined target_folder (
    echo ERROR: Please provide a folder path.
    exit /b 1
)

if not defined target_folder (
    echo Usage: run_tb.bat .\folder [-wave]
    exit /b 1
)

if not exist "%target_folder%" (
    echo ERROR: Folder "%target_folder%" does not exist.
    exit /b 1
)

pushd "%target_folder%"

:: -----------------------------
:: Create 'work' library if needed
:: -----------------------------
if not exist work (
    echo Creating work library...
    vlib work
)

:: -----------------------------
:: Compile all .sv files
:: -----------------------------
set "file_list="
for %%f in (*.sv) do (
    set "file_list=!file_list! %%f"
)

echo Compiling files: !file_list!
vlog !file_list!
if errorlevel 1 (
    echo ERROR: Compilation failed.
    popd
    exit /b 1
)

:: -----------------------------
:: Detect top module (testbench)
:: -----------------------------
set "top_module="
for %%f in (*.sv) do (
    findstr /I /R /C:"module tb_" "%%f" >nul && set "top_module=%%~nf"
)

if not defined top_module (
    echo ERROR: No top-level testbench module found.
    echo HINT: Make sure your testbench file starts with: module tb_*
    popd
    exit /b 1
)

echo Top-level testbench detected: %top_module%

:: -----------------------------
:: Create simulation script
:: -----------------------------
set "do_file=sim.do"
(
    echo vsim -c work.%top_module%
    if "%wave_option%"=="-wave" (
        echo add wave *
        echo log -r /*
    )
    echo run -all
) > %do_file%

:: -----------------------------
:: Run simulation
:: -----------------------------
echo Running simulation...
vsim -c -do %do_file%

popd
endlocal
