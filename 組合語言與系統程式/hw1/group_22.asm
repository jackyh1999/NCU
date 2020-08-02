TITLE ASM
INCLUDE irvine32.inc
main  EQU start@0
.data
.code
main PROC
	mov al, 31	;last two digits of leader?™s students ID
	mov ah, 32	;last two digits of member?™s students ID
	mov ax, 2531h	;last four digits of student?™s ID in hexadecimal
	mov dx, 0EEEAh	;let the value of dx is eeea
	sub dx, ax	;value of dx subtracting by ax
            exit
main ENDP
END main

