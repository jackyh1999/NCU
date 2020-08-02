INCLUDE Irvine32.inc
.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitcode:dword
DifferentInputs proto, v1:dword, v2:dword, v3:dword
main EQU start@0
.data
.code
main proc
	invoke DifferentInputs,2,2,3
	invoke DifferentInputs,2,3,2
	invoke DifferentInputs,3,5,5
	invoke DifferentInputs,2,2,2
	invoke DifferentInputs,104522064,106502531,106502532
	
	call WaitMsg
	invoke ExitProcess,0
main Endp

DifferentInputs proc,
	v1:dword, v2:dword, v3:dword
	mov eax,v1
	cmp v2,eax
	je Label_Equal
	cmp v3,eax
	je Label_Equal
	mov eax,v2
	cmp v3,eax
	je Label_Equal
	mov eax,1
	jmp exit_label
	
Label_Equal:
	mov eax,0
	
exit_label:
	call DumpRegs
	ret
DifferentInputs endp

end main