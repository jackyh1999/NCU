Title ASM_practice_003 (group_22.asm)

Include Irvine32.inc

main EQU start@0
.data
myID byte "106502531"
size_ID = 9
myID2 byte "106502532"
size_ID2 = 9

.code
Convert PROC Uses eax
	L1:
		mov al,[esi]  ;al = the value esi point to
		add al,11h    ;al += 11h
		mov [esi],al  ;the value of esi point to = al
		inc esi       ;esi++
		loop L1       
	ret
Convert ENDP

Convert2 PROC
        push eax
	L1:           
		mov al,[esi]
		add al,11h
		mov [esi],al
		inc esi
		loop L1
        pop eax
	ret
Convert2 ENDP

main PROC
	mov eax,9999h         ;eax=9999h
        mov ebx,9999h         ;ebx=9999h
        mov edx,9999h         ;edx=9999h
	mov esi,OFFSET myID   ;esi=address of myID
	mov ecx,size_ID       ;ecx=size if myID
	call Convert          ;call procedure Convert
	mov esi,OFFSET myID2
	mov ecx,size_ID2
	call Convert2
	
	exit
main ENDP
END main
	