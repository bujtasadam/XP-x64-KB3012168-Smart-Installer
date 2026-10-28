@echo off
setlocal enabledelayedexpansion
title KB3012168 Smart Installer Script
cls

echo =======================================================
echo        KB3012168 AUTOMATED SMART INSTALLER
echo =======================================================
echo.

set "TARGET_EXE=WindowsServer2003-KB3012168-x64-ENU.exe"
set "EXTRACT_DIR=%~dp0gdi_temporary"

:: 1. Check if the original Microsoft installer is present
if not exist "%TARGET_EXE%" (
    echo [ERROR] %TARGET_EXE% was not found in this folder!
    echo Please download it and place it right next to this .bat file.
    pause
    exit /b
)

:: 2. Extract the update to a temporary folder
echo [1/6] Extracting the update packages...
if exist "%EXTRACT_DIR%" rd /s /q "%EXTRACT_DIR%"
mkdir "%EXTRACT_DIR%"
"%TARGET_EXE%" /x:"%EXTRACT_DIR%" /q
echo [OK] Extraction completed successfully.
echo.

:: 3. Backup the current system VBScript files
echo [2/6] Backing up your current VBScript files...
if not exist "C:\Windows\System32\vbscript.dll" (
    echo [ERROR] System cannot locate C:\Windows\System32\vbscript.dll!
    pause
    exit /b
)
copy /y "C:\Windows\System32\vbscript.dll" "%~dp0vbscript_64_original.bak" >nul
if exist "C:\Windows\SysWOW64\vbscript.dll" (
    copy /y "C:\Windows\SysWOW64\vbscript.dll" "%~dp0vbscript_32_original.bak" >nul
)
echo [OK] Original backups saved next to the script.
echo.

:: 4. Bypass Windows File Protection (WFP) via DllCache + system folders
echo [3/6] Swapping VBScript files (DllCache + System paths)...

:: 64-bit file swap
if exist "C:\Windows\System32\DllCache" (
    copy /y "%EXTRACT_DIR%\SP2QFE\vbscript.dll" "C:\Windows\System32\DllCache\vbscript.dll" >nul
)
copy /y "%EXTRACT_DIR%\SP2QFE\vbscript.dll" "C:\Windows\System32\vbscript.dll" >nul

:: 32-bit file swap (SysWOW64 for compatibility)
if exist "C:\Windows\SysWOW64" (
    if exist "C:\Windows\System32\DllCache" (
        copy /y "%EXTRACT_DIR%\SP2QFE\wow\wvbscript.dll" "C:\Windows\System32\DllCache\wvbscript.dll" >nul
    )
    copy /y "%EXTRACT_DIR%\SP2QFE\wow\wvbscript.dll" "C:\Windows\SysWOW64\vbscript.dll" >nul
)

echo.
echo [ATTENTION] If the Windows File Protection (WFP) popup alert appears now:
echo             Click "CANCEL", then click "YES" to keep the files!
echo             Waiting 10 seconds for you to handle the popup...
ping -n 11 127.0.0.1 >nul
echo.

:: 5. Run the original untouched update.exe with custom parameters
echo [4/6] Launching the official Microsoft update.exe in the background...
echo       (This might take around 30 seconds, please wait...)
"%EXTRACT_DIR%\update\update.exe" /passive /norestart /f /o
echo [OK] Microsoft Installer finished execution.
echo.

:: 6. Restore the original modern VBScript environment
echo [5/6] Restoring your original VBScript environment...

:: 64-bit restore
if exist "C:\Windows\System32\DllCache" (
    copy /y "%~dp0vbscript_64_original.bak" "C:\Windows\System32\DllCache\vbscript.dll" >nul
)
copy /y "%~dp0vbscript_64_original.bak" "C:\Windows\System32\vbscript.dll" >nul

:: 32-bit restore
if exist "%~dp0vbscript_32_original.bak" (
    if exist "C:\Windows\System32\DllCache" (
        copy /y "%~dp0vbscript_32_original.bak" "C:\Windows\System32\DllCache\wvbscript.dll" >nul
    )
    copy /y "%~dp0vbscript_32_original.bak" "C:\Windows\SysWOW64\vbscript.dll" >nul
)
echo [OK] Original files restored.
echo.

:: 7. Cleanup temporary folders
echo [6/6] Cleaning up temporary files...
rd /s /q "%EXTRACT_DIR%"
del "%~dp0vbscript_64_original.bak" 2>nul
del "%~dp0vbscript_32_original.bak" 2>nul
echo [OK] Cleanup done.
echo.
echo =======================================================
echo Installation SUCCESSFULLY completed!
echo GDI+ (KB3012168) has been registered into the system.
echo Please REBOOT your computer to finalize changes.
echo =======================================================
pause
exit
