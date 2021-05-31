TITLE hw2 (106502531.asm)

INCLUDE Irvine32.inc
 
main          EQU start@0

.data
	
ChStrs byte "    @   "
       byte "   @@   "
       byte "  @ @   "
       byte "    @   "
       byte "    @   "
       byte "    @   "
       byte "    @   "
       byte "  @@@@@ "

BitStrs byte 8 dup(?)

.code

change PROC uses ecx

	mov ecx,8

	L8:
		mov al,ChStrs[esi]
		test ChStrs[esi],00100000b
		jnz L9

       		sub al,63d
		push ecx
		dec ecx

      		L3:	
			shl al,1
		loop L3

		pop ecx
		push esi
		shr esi,3
		add BitStrs[esi],al
		pop esi

		L9:

		inc esi

	loop L8

	ret

change ENDP

main PROC

xor esi,esi
mov ecx,8

L1:
	call change
loop L1

xor esi,esi
mov ecx,8

L4:
	movzx eax,BitStrs[esi]
	mov ebx,type BitStrs[esi]
	call WriteBinB 	
	inc esi
	call Crlf
loop L4

exit
main ENDP
END main