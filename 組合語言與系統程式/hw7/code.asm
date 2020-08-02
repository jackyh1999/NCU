TITLE Week10 Lab (code.asm)

INCLUDE Irvine32.inc

.stack 4096

ExitProcess proto,dwExitCode:dword
FindLargest proto,aPtr:ptr sdword,arraySize:dword

main EQU start@0

.data

Ex1Array sdword 105522063, 106502531, 106502532
Ex2Array sdword -105522063, -106502531, -106502532

.code

main proc
	
	invoke FindLargest, offset Ex1Array, lengthof Ex1Array
	invoke FindLargest, offset Ex2Array, lengthof Ex2Array
	call WaitMsg
	invoke ExitProcess,0

main endp

FindLargest proc,aPtr:ptr sdword,arraySize:dword
	push esi
	push ecx
	mov eax,80000001h
	mov esi,aPtr
	mov ecx,arraySize
	L1: 
		cmp [esi],eax
		jng L2
		mov eax,[esi]
	L2:
		add esi,4
		loop L1
	
	call WriteInt
	call Crlf
	pop ecx
	pop esi
	ret
	
FindLargest endp

end main
