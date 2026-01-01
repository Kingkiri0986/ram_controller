@echo off
echo ====================================
echo RAM Controller Simulation Script
echo ====================================
echo.

REM Change to project directory - MODIFY THIS PATH TO YOUR ACTUAL PATH
cd /d "%~dp0"

echo Current directory: %CD%
echo.

REM Check if rtl files exist
if not exist "rtl\ram.v" (
    echo ERROR: rtl\ram.v not found!
    pause
    exit /b
)

if not exist "rtl\ram_controller.v" (
    echo ERROR: rtl\ram_controller.v not found!
    pause
    exit /b
)

if not exist "rtl\top.v" (
    echo ERROR: rtl\top.v not found!
    pause
    exit /b
)

if not exist "testbench\tb_top.v" (
    echo ERROR: testbench\tb_top.v not found!
    pause
    exit /b
)

echo All source files found!
echo.

REM Create sim directory if it doesn't exist
if not exist "sim" mkdir sim

echo Compiling Verilog files...
iverilog -o sim\ram_controller.vvp rtl\ram.v rtl\ram_controller.v rtl\top.v testbench\tb_top.v

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Compilation failed!
    pause
    exit /b
)

echo Compilation successful!
echo.

echo Running simulation...
vvp sim\ram_controller.vvp

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Simulation failed!
    pause
    exit /b
)

echo.
echo ====================================
echo Simulation Complete!
echo Waveform file: sim\ram_controller.vcd
echo Open with GTKWave to view waveforms
echo ====================================
pause
```