@echo off
TITLE CyberSunil OS - Windows ISO Builder
cd /d "%~dp0"

where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [-] Error: Python is not installed or not in PATH!
    echo Please install Python 3 or run the build via GitHub / WSL.
    pause
    exit /b 1
)

python tools\windows_builder.py
pause
