rem Credits goes go: https://www.bleepingcomputer.com/forums/t/759880/kb5006670-network-printer-problems-again-this-month/page-4
rem saving this for the future in here
@echo off
REM 10.0.19041.1288 bad file comes from KB5006670

rem will mabe make an improvement later...
rem :choice
rem set /P c="Please enter the full domain name
rem if /I "%c%" EQU "Y" goto :_start
remm if /I "%c%" EQU "N" goto :somewhere_else
rem goto :choice


:_start
copy "\\YourDomain.local\netlogon\spoolerfix\win32spl.dll.good" C:\Windows\System32 /y
copy "\\YourDomain.local\netlogon\spoolerfix\spoolsv.exe.good" C:\Windows\System32 /y

:wmicVersion pathToBinary [variableToSaveTo]
setlocal

:_test_win32spl
set "item1=C:\Windows\System32\win32spl.dll"
set "item1=%item1:\=\\%"
set "item2=C:\Windows\System32\win32spl.dll.good"
set "item2=%item2:\=\\%"

for /f "usebackq delims=" %%a in (`"WMIC DATAFILE WHERE name='%item1%' get Version /format:Textvaluelist"`) do (
    for /f "delims=" %%# in ("%%a") do set "%%#")
set existver=%version%
set version=
for /f "usebackq delims=" %%a in (`"WMIC DATAFILE WHERE name='%item2%' get Version /format:Textvaluelist"`) do (
    for /f "delims=" %%# in ("%%a") do set "%%#")
set goodver=%version%
set version=
echo %existver%
echo %goodver%

IF %goodver%==%existver% echo "Files are same version" && goto _test_spoolsv
IF "%existver%"=="10.0.19041.1288" echo "Files are bad version" && goto _fix_win32spl
IF NOT %goodver%==%existver% echo "Files are different version" && goto _test_spoolsv

:_test_spoolsv
set "item1=C:\Windows\System32\spoolsv.exe"
set "item1=%item1:\=\\%"
set "item2=C:\Windows\System32\spoolsv.exe.good"
set "item2=%item2:\=\\%"

for /f "usebackq delims=" %%a in (`"WMIC DATAFILE WHERE name='%item1%' get Version /format:Textvaluelist"`) do (
    for /f "delims=" %%# in ("%%a") do set "%%#")
set existver=%version%
set version=
for /f "usebackq delims=" %%a in (`"WMIC DATAFILE WHERE name='%item2%' get Version /format:Textvaluelist"`) do (
    for /f "delims=" %%# in ("%%a") do set "%%#")
set goodver=%version%
set version=
echo %existver%
echo %goodver%

IF %goodver%==%existver% echo "Files are same version" && goto _end
IF "%existver%"=="10.0.19041.1288" echo "Files are bad version" && goto _fix_spoolsv
IF NOT %goodver%==%existver% echo "Files are different version" && goto _end
goto _end

:_fix_win32spl
net stop spooler
timeout /t 3 /nobreak
Takeown /A /F C:\Windows\System32\win32spl.dll
icacls  "C:\Windows\System32\win32spl.dll" /grant builtin\administrators:F
icacls  "C:\Windows\System32\win32spl.dll" /grant SYSTEM:F
ren  C:\Windows\System32\win32spl.dll win32spl-%existver%.dll
copy  C:\Windows\System32\win32spl.dll.good C:\Windows\System32\win32spl.dll /Y
goto _test_spoolsv

:_fix_spoolsv
net stop spooler
timeout /t 3 /nobreak
Takeown /A /F C:\Windows\System32\spoolsv.exe
icacls  "C:\Windows\System32\spoolsv.exe" /grant builtin\administrators:F
icacls  "C:\Windows\System32\spoolsv.exe" /grant SYSTEM:F
ren  C:\Windows\System32\spoolsv.exe spoolsv-%existver%.exe
copy  C:\Windows\System32\spoolsv.exe.good C:\Windows\System32\spoolsv.exe /Y
goto _end

:_end
net start spooler
exit
