@echo off
setlocal

echo [1/2] Assembling engine.asm and logic.asm...
ml /nologo /c /coff /I C:\Irvine engine.asm logic.asm
if errorlevel 1 (
    echo.
    echo [ERROR] Assembly step failed.
    exit /b %ERRORLEVEL%
)

echo [2/2] Linking game.exe...
link /nologo /SUBSYSTEM:CONSOLE /LIBPATH:C:\Irvine engine.obj logic.obj Irvine32.lib Kernel32.Lib User32.Lib /OUT:game.exe
if errorlevel 1 (
    echo.
    echo [ERROR] Link step failed.
    exit /b %ERRORLEVEL%
)

echo Build succeeded: game.exe is ready.
