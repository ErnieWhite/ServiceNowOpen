@echo off
REM ============================================================================
REM Script Name: open-servicenow-directory.bat
REM Description: Opens or creates a directory in the ServiceNow folder and 
REM              displays it in File Explorer.
REM
REM Usage: open-servicenow-directory.bat "DirectoryName"
REM        open-servicenow-directory.bat /? (for help)
REM
REM Parameters:
REM   %1 - Directory name to open or create (required)
REM   /? - Display help information
REM
REM Examples:
REM   open-servicenow-directory.bat "Project1"
REM   open-servicenow-directory.bat "New Project"
REM   open-servicenow-directory.bat /?
REM
REM Requirements:
REM   - Windows 11
REM   - Access to the specified OneDrive path
REM
REM Author: Created for ServiceNow directory management
REM Version: 1.0
REM Created: 2025
REM ============================================================================

setlocal enabledelayedexpansion

REM Configuration
set "BASE_DIR=C:\Users\awhite\OneDrive - Morsco\Documents\ServiceNow"

REM Display help if requested or no parameters provided
if "%~1"=="/?" goto :show_help
if "%~1"=="?" goto :show_help
if "%~1"=="" goto :show_help

REM Get the directory name parameter
set "DIR_NAME=%~1"

echo ServiceNow Directory Manager
echo ================================

REM Validate directory name
if "!DIR_NAME!"=="" (
    echo ERROR: Directory name cannot be empty.
    goto :error_exit
)

REM Remove quotes if present (they're added back when needed)
set "DIR_NAME=!DIR_NAME:"=!"

REM Check for invalid characters (basic check)
echo !DIR_NAME! | findstr /R /C:"[<>:\"/\\|?*]" >nul
if !errorlevel! equ 0 (
    echo WARNING: Directory name contains potentially invalid characters.
    echo Some characters may be removed or replaced by the system.
)

REM Construct full path
set "FULL_PATH=!BASE_DIR!\!DIR_NAME!"

echo Target directory: !FULL_PATH!

REM Check if base directory exists
if not exist "!BASE_DIR!" (
    echo ERROR: Base directory does not exist: !BASE_DIR!
    echo Please ensure OneDrive is properly synced and the path is correct.
    goto :error_exit
)

REM Check if target directory exists
if exist "!FULL_PATH!" (
    echo SUCCESS: Directory already exists: !DIR_NAME!
) else (
    echo INFO: Directory does not exist. Creating: !DIR_NAME!
    
    REM Create directory
    mkdir "!FULL_PATH!" 2>nul
    if !errorlevel! neq 0 (
        echo ERROR: Failed to create directory: !DIR_NAME!
        echo Please check permissions and path validity.
        goto :error_exit
    )
    
    echo SUCCESS: Successfully created directory: !DIR_NAME!
)

REM Check if File Explorer is running
tasklist /FI "IMAGENAME eq explorer.exe" 2>nul | find /I /N "explorer.exe" >nul
if !errorlevel! neq 0 (
    echo INFO: File Explorer is not running. It will be started automatically.
)

REM Open directory in File Explorer
echo INFO: Opening directory in File Explorer...
start "" explorer "!FULL_PATH!"

if !errorlevel! equ 0 (
    echo SUCCESS: Opened directory in File Explorer: !FULL_PATH!
    echo SUCCESS: Operation completed successfully!
) else (
    echo ERROR: Failed to open directory in File Explorer
    goto :error_exit
)

goto :end

:show_help
echo.
echo ServiceNow Directory Manager - Help
echo ===================================
echo.
echo This script opens or creates a directory in the ServiceNow folder and
echo displays it in File Explorer.
echo.
echo USAGE:
echo   %~nx0 "DirectoryName"
echo   %~nx0 /? ^(for help^)
echo.
echo PARAMETERS:
echo   DirectoryName  - The name of the directory to open or create ^(required^)
echo   /?            - Display this help information
echo.
echo EXAMPLES:
echo   %~nx0 "Project1"
echo   %~nx0 "New Project"
echo   %~nx0 /?
echo.
echo DESCRIPTION:
echo   The script checks if the specified directory exists in:
echo   !BASE_DIR!
echo.
echo   If the directory exists, it opens it in File Explorer.
echo   If the directory doesn't exist, it creates the directory first
echo   and then opens it in File Explorer.
echo.
echo   If File Explorer is not running, it will be launched automatically.
echo.
echo REQUIREMENTS:
echo   - Windows 11
echo   - Access to the specified OneDrive path
echo.
goto :end

:error_exit
echo.
echo Script execution failed. Exit code: 1
exit /b 1

:end
echo.
pause
exit /b 0