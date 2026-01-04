:: Author: Doruk Aysor
:: Purpose: Revert Admin PC sharing and security settings
@echo off
setlocal

echo ========================================================
echo      REVERTING ADMIN SETUP
echo ========================================================
echo Reverting Changes...

:: 1. Removing Network Shares
echo Removing SMB shares...
net share public /delete >nul 2>&1
net share private$ /delete >nul 2>&1

:: 2. Disabling Guest Account
echo Disabling Guest account...
net user Guest /active:no >nul 2>&1

:: 3. Restoring Folder Visibility
echo Removing hidden attributes from folder...
attrib -h "C:\shared\.private" >nul 2>&1

:: 4. Resetting NTFS Permissions
echo Resetting folder permissions to defaults...
icacls "C:\shared\public" /reset /T /C /Q >nul 2>&1
icacls "C:\shared\.private" /reset /T /C /Q >nul 2>&1

echo.
echo ========================================================
echo ✅ :: REVERTING COMPLETE
echo ✅ :: Network shares removed
echo ✅ :: Guest account disabled
echo ✅ :: Folders are no longer shared
echo ✅ :: NTFS permissions reset
echo ========================================================
pause