rem Created by http://github.com/djdomi under GPL v3


@echo off
setlocal

REM Definieren des Registryschlüssels
set "regKey=HKEY_LOCAL_MACHINE\SOFTWARE\PostgreSQL"

REM Ermitteln der installierten PostgreSQL-Versionen aus der Registry
for /f "tokens=*" %%A in ('reg query "%regKey%" /s /k ^| findstr /i "PostgreSQL"') do (
  set "versionKey=%%A"
  setlocal enabledelayedexpansion
  for /f "usebackq tokens=2*" %%B in (`reg query "!versionKey!" /v "Base Directory" ^| findstr /i "Base Directory"`) do (
    set "installPath=%%C"
    set "version=!versionKey:~-3!"
    echo !version!: !installPath!
    set "latestVersion=!version!"
    endlocal
  )
)

REM Überprüfen, ob nur eine Version vorhanden ist
if "%latestVersion%"=="" (
  echo Es wurden keine PostgreSQL-Versionen gefunden.
  exit /b
)

REM Überprüfen, ob mehr als eine Version vorhanden ist
if not "%latestVersion%"=="" (
  echo Es wurden mehrere PostgreSQL-Versionen gefunden.
  set /p "selectedVersion=Möchten Sie die neueste Version (%latestVersion%) verwenden? (j/n): "
  if /i "%selectedVersion%"=="n" (
    set /p "selectedVersion=Geben Sie die gewünschte PostgreSQL-Version ein: "
  ) else (
    set "selectedVersion=%latestVersion%"
  )
)

REM Überprüfen, ob die ausgewählte Version vorhanden ist
for /f "tokens=*" %%D in ('reg query "%regKey%" /s /k ^| findstr /i "!selectedVersion!"') do (
  set "selectedVersionKey=%%D"
)

REM Überprüfen, ob die ausgewählte Version gefunden wurde
if not defined selectedVersionKey (
  echo Die ausgewählte PostgreSQL-Version wurde nicht gefunden.
  exit /b
)

REM Auslesen des Installationspfads der ausgewählten Version
for /f "usebackq tokens=2*" %%E in (`reg query "%selectedVersionKey%" /v "Base Directory" ^| findstr /i "Base Directory"`) do (
  set "selectedInstallPath=%%F"
)

REM Überprüfen, ob der Installationspfad vorhanden ist
if not exist "%selectedInstallPath%" (
  echo PostgreSQL Installationspfad nicht gefunden.
  exit /b
)

REM Kopieren der Datei in den Installationspfad
copy "test.txt" "%selectedInstallPath%"

echo Die Datei wurde erfolgreich in das PostgreSQL-Verzeichnis der Version %selectedVersion% kopiert.

endlocal
