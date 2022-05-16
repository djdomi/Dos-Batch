@echo off
erase "%TEMP%\*.*" /f /s /q >NUL
for /D %%i in ("%TEMP%\*") do RD /S /Q "%%i" >NUL

erase "%TMP%\*.*" /f /s /q >NUL
for /D %%i in ("%TMP%\*") do RD /S /Q "%%i" >NUL

erase "%ALLUSERSPROFILE%\TEMP\*.*" /f /s /q >NUL
for /D %%i in ("%ALLUSERSPROFILE%\TEMP\*") do RD /S /Q "%%i" >NUL

erase "%SystemRoot%\TEMP\*.*" /f /s /q >NUL
for /D %%i in ("%SystemRoot%\TEMP\*") do RD /S /Q "%%i" >NUL


@rem Clear IE cache -  (Deletes Temporary Internet Files Only)
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8 >NUL
erase "%LOCALAPPDATA%\Microsoft\Windows\Tempor~1\*.*" /f /s /q >NUL
for /D %%i in ("%LOCALAPPDATA%\Microsoft\Windows\Tempor~1\*") do RD /S /Q "%%i" >NUL

@rem Clear Google Chrome cache
erase "%LOCALAPPDATA%\Google\Chrome\User Data\*.*" /f /s /q >NUL
for /D %%i in ("%LOCALAPPDATA%\Google\Chrome\User Data\*") do RD /S /Q "%%i" >NUL


@rem Clear Firefox cache
erase "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*.*" /f /s /q >NUL
for /D %%i in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do RD /S /Q "%%i" >NUL

