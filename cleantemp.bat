@echo off
forfiles /p %WINDIR%\temp /s /d -7 /c "cmd /c  if @isdir==FALSE del /s /q @path"
forfiles /p %WINDIR%\temp /s /d -14 /c "cmd /c  if @isdir==TRUE rd /s /q @path"
