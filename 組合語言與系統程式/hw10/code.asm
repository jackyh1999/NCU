title In_class_Exercise (code.asm)
INCLUDE Irvine32.inc

Str_remove PROTO,pStart:PTR BYTE,nChars:DWORD

main  EQU start@0 
.data
target BYTE "106502531106502532ABCDEF",0

.code
main PROC

	mov edi, offset target
	mov al, "2"
	mov ecx, lengthof target
	cld
	repne scasb
	dec edi
	mov eax, offset target
	sub edi, eax
	call DumpRegs

	mov edx,OFFSET target
	call WriteString
	call Crlf
	INVOKE Str_remove, offset target, lengthof target
	mov edx,OFFSET target
	call WriteString
	call Crlf
	call WaitMsg
	exit
main ENDP

Str_remove PROC,
	pStart:PTR BYTE,
	nChars:DWORD

	INVOKE Str_length, pStart
	mov	ecx,eax

	.IF nChars <= ecx
	  sub ecx, nChars
	.ENDIF

	mov esi, offset target
	add esi, edi	
	mov edi, offset target	

	cld               
	rep movsb	     

	mov	BYTE PTR [edi],0

Exit_proc:
	ret
Str_remove ENDP
END main
