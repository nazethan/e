:: Author: Doruk Aysor
:: Purpose: Connects Managers to Private (Hidden) & Public. Full Network Speed.
@echo off
setlocal

echo ========================================================
echo      MANAGERS SETUP
echo ========================================================
echo Starting setup...

:: 1. Allow Insecure Guest Auth (Required for Win 11 Password-less shares)
echo Enabling Password-less file sharing support...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v AllowInsecureGuestAuth /t REG_DWORD /d 1 /f >nul 2>&1

:: 2. Mapping Network Drives
echo Mapping Network Drives...
net use Z: /delete /y >nul 2>&1
net use Y: /delete /y >nul 2>&1

:: Mapping Z: to Private (Hidden) Share - No user/pass needed
net use Z: \\LAB-02-S01\private$ /persistent:yes

:: Mapping Y: to Public Share
net use Y: \\LAB-02-S01\public /persistent:yes

:: 3. Removing Bandwidth Limits (Ensure Full Network Speed)
echo Optimizing Network...
powershell -Command "Remove-NetQosPolicy -Name 'StudentLimit' -ErrorAction SilentlyContinue"
netsh int tcp set global autotuninglevel=normal

echo.
echo ========================================================
echo ✅ :: SETUP COMPLETE
echo ========================================================
echo Z: Drive -> Private (Hidden)
echo Y: Drive -> Public
echo ========================================================
pause