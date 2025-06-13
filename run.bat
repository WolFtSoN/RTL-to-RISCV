@echo off
setlocal enabledelayedexpansion

:: Remove 'work' folder if it exists
if exist "work" (
    rmdir /s /q "work"
)

:: Confirm deletion
if not exist "work" (
    echo 'work' folder successfully deleted.
) else (
    echo Failed to delete 'work' folder.
    exit /b 1
)

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

@REM :: -----------------------------
@REM :: Compile all .sv files
@REM :: -----------------------------
@REM set "file_list="
@REM for %%f in (*.sv) do (
@REM     set "file_list=!file_list! %%f"
@REM )
:: -----------------------------
:: Recursively compile all .sv files
:: -----------------------------
set "file_list="
for /R %%f in (*.sv) do (
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
    @REM echo vsim -c work.%top_module%
    @REM if "%wave_option%"=="-wave" (
    @REM     @REM echo add wave *
    @REM     @REM echo log -r /*
    @REM     echo vcd file waveform.vcd
    @REM     echo vcd add -r /*
    @REM     echo vcd flush
    @REM     echo vcd off
    @REM )
    @REM echo run -all
    
    echo vsim -c work.%top_module%
    if "%wave_option%"=="-wave" (
        echo vcd file waveform.vcd
        echo vcd add -r /*
        echo vcd on
    )
    echo run -all
    if "%wave_option%"=="-wave" (
        echo vcd flush
        echo vcd off
    )
    echo quit
) > %do_file%


:: -----------------------------
:: Run simulation
:: -----------------------------
echo Running simulation...
if "%wave_option%"=="-wave" (
    @REM Run and check with ModelSim, and waveform with gtkwave
    vsim -c -do %do_file%   
    gtkwave waveform.vcd
) else (
    vsim -c -do %do_file%
)


popd
endlocal
