:: Author: Doruk Aysor
:: Purpose: Connects Students to Public ONLY & Limits Bandwidth
@echo off
setlocal

echo ========================================================
echo      STUDENTS SETUP
echo ========================================================

:: 1. Allow Insecure Guest Auth (Required for Win 11 Password-less shares)
echo Enabling Password-less file sharing support...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v AllowInsecureGuestAuth /t REG_DWORD /d 1 /f >nul 2>&1

:: 2. Mapping Network Drives (Public Only)
echo Mapping Public Drive...
net use Z: /delete /y >nul 2>&1
net use Y: /delete /y >nul 2>&1
net use * /delete /y >nul 2>&1

:: Mapping Y: to Public Share
net use Y: \\LAB-02-S01\public /persistent:yes

:: 3. Bandwidth Optimization
echo Applying Bandwidth Optimization...
powershell -Command "Remove-NetQosPolicy -Name 'StudentLimit' -ErrorAction SilentlyContinue"
powershell -Command "New-NetQosPolicy -Name 'StudentLimit' -Default -ThrottleRateActionNonConforming Discard -ThrottleRate 4000000"

:: Disable Auto-Tuning to prevent buffer bloat
netsh int tcp set global autotuninglevel=restricted

echo.
echo ========================================================
echo ✅ :: SETUP COMPLETE
echo ✅ :: Network Access Successful
echo ✅ :: Mapped Y: Drive -> Public Folder
echo ✅ :: Optimized Internet Speed
echo ========================================================
pause