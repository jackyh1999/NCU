@echo off
REM make
REM Assembles and links the 32-bit ASM program into .exe which can be used by WinDBG
REM Uses MicroSoft Macro Assembler version 6.11 and 32-bit Incremental Linker version 5.10.7303
REM Created by Huang 

REM delete related files
del 106502531.lst
del 106502531.obj
del 106502531.ilk
del 106502531.pdb
del 106502531.exe

REM /c          assemble without linking
REM /coff       generate object code to be linked into flat memory model 
REM /Zi         generate symbolic debugging information for WinDBG
REM /Fl		Generate a listing file
 
REM 106502531.asm      The name of the source file 


ML /c /coff /Zi /Fl 106502531.asm
if errorlevel 1 goto terminate

REM /debug              generate symbolic debugging information
REM /subsystem:console  generate console application code
REM /entry:start        entry point from WinDBG to the program 
REM                           the entry point of the program must be _start

REM /out:106502531.exe         output 106502531.exe code
REM 106502531.obj              input 106502531.obj
REM Kernel32.lib        library procedures to be invoked from the program
REM irvine32.lib
REM user32.lib

LINK /debug /subsystem:console  /entry:start /out:106502531.exe 106502531.obj Kernel32.lib irvine32.lib user32.lib
if errorlevel 1 goto terminate

REM Display all files related to this program:
DIR 106502531.*

:terminate
pause
