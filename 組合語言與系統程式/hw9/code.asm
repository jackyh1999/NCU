INCLUDE Irvine32.inc
 
Str_copyN PROTO,
    source:PTR DWORD,   
    target:PTR DWORD,   
    maxChars:DWORD      
 main   EQU start@0
.data
string_1 BYTE "106502531",0   
string_2 BYTE "106502532",0   
 
.code
main PROC
    INVOKE Str_copyN,        
      ADDR string_1 ,        
      ADDR string_2 + 9,     
      (SIZEOF string_2) - 1 
 
    mov  edx,OFFSET string_2
    call WriteString
    call Crlf
    call WaitMsg
    exit
main ENDP
 
Str_copyN PROC USES eax ecx esi edi,
    source:PTR DWORD,           
    target:PTR DWORD,      
    maxChars:DWORD

    mov ecx,maxChars
    mov esi,source 
	mov edi,target 
    cld             
    rep movsb         
    mov eax,0
	stosb
    ret
Str_copyN ENDP
 
END main
