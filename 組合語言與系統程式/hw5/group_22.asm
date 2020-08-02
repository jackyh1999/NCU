Title ASM_practice (group_22.asm)

Include Irvine32.inc

main EQU start@0
.data
myID byte 1,0,6,5,0,2,5,3,1
size_ID = lengthof myID
myID_counts_of_odd byte ?
myID_sum_of_even byte ?
myID_result byte 0

.code

main PROC
            xor bl, bl
	xor dl, dl
	xor esi, esi
	mov ecx, size_ID
	L1:
		mov al, myID[esi]
		test al, 1
		jnz L2
		jmp L3
	L2:
		add bl, 1
		jmp L4
	L3:
		add dl, al
	L4:
		inc esi
		loop L1
	mov myID_counts_of_odd, bl
	mov myID_sum_of_even, dl
	movzx ecx, bl
	L5:
		add myID_result, dl
		loop L5
	exit
main ENDP
END main
	