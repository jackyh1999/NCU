TITLE ASM         


INCLUDE Irvine32.inc

 
main          EQU start@0

.data

Val1 SBYTE 03h
Val2 SBYTE 02h
Val3 SBYTE 8fh
Rval SDWORD ?	

.code
main PROC

	movsx eax,Val1
	movsx ebx,Val2
	add eax,ebx
	shl eax,1	
	movsx ecx,Val3
	sub ecx,eax
	shl eax,1
	sub ecx,eax
	sub ecx,eax
	sub ecx,eax
	neg ecx
	mov Rval,ecx

	exit
main ENDP
END main

