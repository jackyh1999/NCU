TITLE homework3 (106502531_hw3.asm)

INCLUDE Irvine32.inc

CountMatches proto,aPtr:ptr sdword,bPtr:ptr sdword,maxChars:dword

main EQU start@0

.data

array1 sdword 10,5,4,-6,2,11,12
array2 sdword 10,5,3,1,4,2,-6

.code

main proc
	
	xor eax,eax
	invoke CountMatches, offset array1, offset array2, lengthof array1
	call writeDec
	call Crlf
	call WaitMsg

main endp

CountMatches proc,aPtr:ptr sdword,bPtr:ptr sdword,maxChars:dword
	mov esi,aPtr
	mov edi,bPtr
	mov ecx,maxChars
	L1:
		mov ebx,[esi]
		mov edx,[edi]
		cmp ebx,edx
		jne no_match_label
		inc eax
	no_match_label:
	add esi,4
	add edi,4
	loop L1
	ret
CountMatches endp

end main
