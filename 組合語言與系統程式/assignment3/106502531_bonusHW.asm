TITLE bonus (106502531_bonusHW.asm)

INCLUDE Irvine32.inc

Str_nextWord proto,pString:ptr byte,delimiter:byte

main EQU start@0
.data

testStr byte"ABC\DE\FGHIJK\LM",0

.code

Str_nextword proc,pString:ptr byte,delimiter:byte
	mov bl,delimiter
	mov ecx,lengthof testStr
	Check_label:
		mov bh,[esi]
		cmp bh,bl
		je return_label
		cmp bh,0
		je not_found_label
		inc esi
		loop Check_label
	not_found_label:
		inc ecx
		ret
	return_label:	
		xor [esi],bh
		ret

Str_nextword endp

main proc
	call Clrscr
	mov edx,offset testStr
	call WriteString
	call Crlf
	mov esi,offset testStr
	mov bl,05Ch
L1:
	invoke Str_nextword,esi,bl
	jnz Exit_prog
	inc esi
	mov eax,esi
	mov edx,eax
	call WriteString
	call Crlf
	jmp L1

Exit_prog:
	call WaitMsg
	Exit
main endp
end main
