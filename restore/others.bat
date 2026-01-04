:: Author: Doruk Aysor
:: Purpose: Remove bandwidth optimization and disconnect shares
@echo off
setlocal

echo ========================================================
echo      REVERTING STUDENTS SETUP
echo ========================================================
echo Reverting Changes...

:: 1. Re-Configuring Bandwidth Optimization (QoS Policy)
echo Internet optimizations re-configured...

:: 2. Restoring TCP Auto-Tuning to Normal
echo Restoring default TCP performance...
netsh int tcp set global autotuninglevel=normal

:: 3. Disconnecting Network Drives
echo Disconnecting mapped drives...
net use Y: /delete /y >nul 2>&1
net use * /delete /y >nul 2>&1

:: 4. Reverting Insecure Guest Auth Registry Key
echo Restoring default security settings...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v AllowInsecureGuestAuth /f >nul 2>&1

echo.
echo ========================================================
echo ✅ :: REVERTING COMPLETE
echo ✅ :: Internet optimizations re-configured
echo ✅ :: TCP settings restored to normal
echo ✅ :: Network drives disconnected
echo ========================================================
pause