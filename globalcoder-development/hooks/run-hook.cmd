: << 'CMDBLOCK'
@echo off
REM Polyglot wrapper: runs .sh scripts cross-platform
REM Usage: run-hook.cmd <script-name> [args...]
REM The script should be in the same directory as this wrapper

setlocal

if "%~1"=="" (
    echo run-hook.cmd: missing script name >&2
    exit /b 1
)

REM Locate bash: prefer Git for Windows in standard locations, then PATH
set "BASH_EXE="
if exist "%PROGRAMFILES%\Git\bin\bash.exe" set "BASH_EXE=%PROGRAMFILES%\Git\bin\bash.exe"
if not defined BASH_EXE if exist "%PROGRAMFILES(X86)%\Git\bin\bash.exe" set "BASH_EXE=%PROGRAMFILES(X86)%\Git\bin\bash.exe"
if not defined BASH_EXE if exist "%LOCALAPPDATA%\Programs\Git\bin\bash.exe" set "BASH_EXE=%LOCALAPPDATA%\Programs\Git\bin\bash.exe"
if not defined BASH_EXE for /f "delims=" %%i in ('where bash 2^>nul') do if not defined BASH_EXE set "BASH_EXE=%%i"

if not defined BASH_EXE (
    echo run-hook.cmd: bash not found. Install Git for Windows or add bash to PATH. >&2
    exit /b 1
)

"%BASH_EXE%" -l "%~dp0%~1" %2 %3 %4 %5 %6 %7 %8 %9
exit /b
CMDBLOCK

# Unix shell runs from here
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="$1"
shift
"${SCRIPT_DIR}/${SCRIPT_NAME}" "$@"
