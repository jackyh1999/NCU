@echo off

if not exist rc\rsrc.rc goto over1
exe\rc.exe /v rc\rsrc.rc
exe\cvtres.exe /machine:ix86 rc\rsrc.res
:over1

if exist calculator.obj del calculator.obj
if exist calculator.exe del calculator.exe

exe\ml.exe /c /coff calculator.asm
if errorlevel 1 goto errasm

if not exist rc\rsrc.obj goto nores

exe\link.exe /SUBSYSTEM:WINDOWS calculator.obj rc\rsrc.obj
if errorlevel 1 goto errlink

dir calculator.*
goto TheEnd

:nores
exe\link.exe /SUBSYSTEM:WINDOWS calculator.obj
if errorlevel 1 goto errlink
dir %1
goto TheEnd

:errlink
echo _
echo Link error
goto TheEnd

:errasm
echo _
echo Assembly Error
goto TheEnd

:TheEnd

pause

