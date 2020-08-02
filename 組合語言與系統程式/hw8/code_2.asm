INCLUDE Irvine32.inc

main EQU start@0

Str_remove PROTO,
	pStart:PTR BYTE,
	nChars:DWORD

.data
target1 BYTE "106502531",0
target2 BYTE "106502532",0
target3 BYTE "999999999",0
.code
main PROC

	INVOKE Str_remove, ADDR target1, 5
	mov edx,OFFSET target1
	call WriteString
	call Crlf
	mov ebx, OFFSET target2
	
	INVOKE Str_remove, ebx, 2
	mov edx, OFFSET target2
	call WriteString
	call Crlf
	
	INVOKE Str_remove, ADDR[target2+1],15
	mov edx, OFFSET target2
	call WriteString
	call Crlf
	call WaitMsg
	exit
	main ENDP
	
Str_remove PROC,
	pStart:PTR BYTE,
	nChars:DWORD
	
	INVOKE Str_length, pStart
	mov ecx,eax
	
	.IF nChars <= ecx
		sub ecx,nChars
	.ENDIF
	
	mov esi,pStart
	add esi,nChars
	mov edi,pStart
	
	cld
	rep movsb
	mov BYTE PTR[edi],0
Exit_proc:
	ret
Str_remove ENDP

END main

	