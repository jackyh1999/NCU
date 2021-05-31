INCLUDE Irvine32.inc
main	EQU start@0
BoxWidth = 7
BoxHeight = 7

.data
boxTop    BYTE 0DAh, (BoxWidth - 2) DUP(0C4h), 0BFh
boxBody   BYTE 0B3h, (BoxWidth - 2) DUP(' '), 0B3h
boxBottom BYTE 0C0h, (BoxWidth - 2) DUP(0C4h),0D9h

outputHandle DWORD 0
bytesWritten DWORD 0
count DWORD 0
xyPosition COORD <10,5>

cellsWritten DWORD ?
attributes0 WORD BoxWidth DUP(0Bh)
attributes1 WORD (BoxWidth-1) DUP(0Ah),0Eh
attributes2 WORD BoxWidth DUP(0Ch)

.code
main PROC

    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    call Clrscr

    INVOKE WriteConsoleOutputAttribute,
      outputHandle,
      ADDR attributes0,
      BoxWidth,
      xyPosition,
      ADDR cellsWritten

    INVOKE WriteConsoleOutputCharacter,
       outputHandle,
       ADDR boxTop,
       BoxWidth,
       xyPosition,
       ADDR count

    inc xyPosition.Y

    mov ecx,(BoxHeight-2)


L1: push ecx
    INVOKE WriteConsoleOutputAttribute,
      outputHandle,
      ADDR attributes1,
      BoxWidth,
      xyPosition,
      ADDR cellsWritten

	INVOKE WriteConsoleOutputCharacter,
       outputHandle,
       ADDR boxBody,
       BoxWidth,
       xyPosition,
       ADDR count

    inc xyPosition.Y
    pop ecx
    loop L1

    INVOKE WriteConsoleOutputAttribute,
      outputHandle,
      ADDR attributes2,
      BoxWidth,
      xyPosition,
      ADDR cellsWritten


    INVOKE WriteConsoleOutputCharacter,
       outputHandle,
       ADDR boxBottom,
       BoxWidth,
       xyPosition,
       ADDR count

    call WaitMsg
    call Clrscr
    exit
main ENDP
END main
