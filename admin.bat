:: Author: Doruk Aysor
:: Purpose: Host PC Setup - Public, Hidden Private Share
@echo off
setlocal

echo ========================================================
echo      ADMIN SETUP - LAB-02-S01
echo ========================================================
echo Starting setup...

:: 1. Enabling Guest Account for Password-less Access
echo Enabling Guest account for network access...
net user Guest /active:yes >nul 2>&1

:: 2. Creating The Directory Structure
echo Creating directories...
if not exist "C:\shared\public" mkdir "C:\shared\public"
if not exist "C:\shared\.private" mkdir "C:\shared\.private"

:: 3. Setting Attributes (Hide the .private folder locally)
attrib +h "C:\shared\.private"

:: 4. Resetting Permissions (NTFS) - Grant access to Everyone
echo Setting NTFS Security permissions...
:: Public
icacls "C:\shared\public" /reset /T /C /Q >nul 2>&1
icacls "C:\shared\public" /grant Everyone:(OI)(CI)F /T /C /Q

:: Private (No password, but folder is hidden locally and on network)
icacls "C:\shared\.private" /reset /T /C /Q >nul 2>&1
icacls "C:\shared\.private" /grant Everyone:(OI)(CI)F /T /C /Q

:: 5. Creating Network Shares (SMB)
echo Creating Network Shares...
net share public /delete >nul 2>&1
net share private$ /delete >nul 2>&1

:: Sharing Public Folder (Visible)
net share public="C:\shared\public" /GRANT:Everyone,FULL /REMARK:"Public Lab Share"

:: Sharing Private Folder (Hidden with $) - No password required!
net share private$="C:\shared\.private" /GRANT:Everyone,FULL /REMARK:"Hidden Share"

:: 6. Configuring Firewall & Network Discovery
echo Configuring Firewall...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes

echo.
echo ========================================================
echo ✅ :: SETUP COMPLETE
echo ========================================================
echo Network Shared Paths:
echo Public Path: \\LAB-02-S01\public
echo Private Path: \\LAB-02-S01\private$ (Hidden)
echo ========================================================
pause