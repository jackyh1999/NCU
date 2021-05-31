TITLE hw1

INCLUDE Irvine32.inc
 
main          EQU start@0

.data
	MyID DWORD ?
Digit0 BYTE 0h
Digit1 BYTE 6h
Digit2 BYTE 5h
Digit3 BYTE 0h
Digit4 BYTE 2h
Digit5 BYTE 5h
Digit6 BYTE 3h
Digit7 BYTE 1h


.code
main PROC

movsx eax,Digit7
movsx ebx,Digit6
shl ebx,4
add eax,ebx
movsx ebx,Digit5
shl ebx,8
add eax,ebx
movsx ebx,Digit4
shl ebx,12
add eax,ebx
movsx ebx,Digit3
shl ebx,16
add eax,ebx
movsx ebx,Digit2
shl ebx,20
add eax,ebx
movsx ebx,Digit1
shl ebx,24
add eax,ebx
movsx ebx,Digit0
shl ebx,28
add eax,ebx
mov MyID,eax
	

	exit
main ENDP
END main