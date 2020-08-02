Title lab6 (group22.asm)

Include Irvine32.inc

main EQU start@0

.data

myID byte "106502531"
size_ID = 9
myID_result byte "106502531",0

.code
convert Macro myID,size_ID,myID_result
	mov ecx,size_ID
	xor esi,esi
	L1:
		mov bl,myID[esi]
		test bl,1b
		jnz L2
		mov bl,'B'
		jmp L3
		L2:
			mov bl,'A'
		L3:
		mov myID_result[esi],bl
		inc esi
	loop L1
ENDM
	
main PROC
	mov eax,106502531d
	call WriteDec
	call Crlf
	convert myID,size_ID,myID_result
	mov edx,OFFSET myID_result
	call WriteString
	call Crlf
	call WaitMsg
	invoke ExitProcess,0
main ENDP
END main