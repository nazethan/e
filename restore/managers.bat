:: Author: Doruk Aysor
:: Purpose: Disconnect Manager drives and revert registry changes
@echo off
setlocal

echo ========================================================
echo      REVERTING MANAGERS SETUP
echo ========================================================
echo Reverting Changes...

:: 1. Disconnecting Network Drives
echo Disconnecting Y: and Z: drives...
net use Z: /delete /y >nul 2>&1
net use Y: /delete /y >nul 2>&1

:: 2. Reverting Insecure Guest Auth Registry Key
echo Restoring default security for guest logons...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v AllowInsecureGuestAuth /f >nul 2>&1

:: 3. Clearing stored credentials (if any)
cmdkey /delete:LAB-02-S01 >nul 2>&1

echo.
echo ========================================================
echo ✅ :: REVERTING COMPLETE
echo ✅ :: Network drives disconnected
echo ✅ :: Credentials Cleared
echo ========================================================
pause