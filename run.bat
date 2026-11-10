@echo off
setlocal

call "%~dp0build.bat"
if errorlevel 1 exit /b %ERRORLEVEL%

cls
"%~dp0game.exe"

