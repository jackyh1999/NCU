.386
.model flat, stdcall
option casemap:none

include inc\windows.inc
include inc\kernel32.inc
include inc\user32.inc
include inc\gdi32.inc
includelib lib\kernel32.lib
includelib lib\user32.lib
includelib lib\gdi32.lib

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
Paint_Proc PROTO :DWORD,:DWORD
search_string proto :ptr byte
String_To_Int proto :ptr byte,:ptr sdword
calculate proto :byte,:sdword,:sdword,:ptr dword
Int_To_String proto :sdword,:ptr byte
Clear_String proto :ptr byte

.data

ClassName db "Window",0
AppName  db "Calculator",0
MenuName db "FirstMenu",0
EditClassName db "edit",0
ButtonClassName db "button",0
ButtonText db "My First Button",0
EditText db "1",0

const10 dword 10
index dword 0
bo byte 0
boo byte 0
clear_bo byte 0
minus_bo byte 0
op byte 0
buffer byte 32 dup(0),0
buffer_int sdword 0
output byte 32 dup(0),0
output_int sdword 0
test_str byte 't'
addrop dword 0

divisor dword 1000000000,100000000,10000000,1000000,100000,10000,1000,100,10,1,0

ButtonText0 db "0",0
ButtonText1 db "1",0
ButtonText2 db "2",0
ButtonText3 db "3",0
ButtonText4 db "4",0
ButtonText5 db "5",0
ButtonText6 db "6",0
ButtonText7 db "7",0
ButtonText8 db "8",0
ButtonText9 db "9",0
ButtonText_plus db "+",0
ButtonText_minus db "-",0
ButtonText_times db "*",0
ButtonText_divide db "/",0
ButtonText_equal db "=",0
ButtonText_clear db "C",0

TestString  db "FGO is good game",0
Hello_string db "Hello, my friend",0
Goodbye_string db "See you again, bye",0
Warn_string db "Can not divided by zero",0
FontName db "Arial Unicode MS",0
MouseClick db 0

scrtxt db "製作人員,",13,10,13,10
       db "106502020 李信鋌",13,10,13,10
       db "106502530 張立彥",13,10,13,10
       db "106502531 洪仲杰",13,10,13,10
       db "Thank you for watching!",13,10,13,10
       db ":)",0



.data?

hInstance dd ?
CommandLine dd ?
hitpoint POINT <>

hwndButton HWND ?
hwndButton0 HWND ?
hwndButton1 HWND ?
hwndButton2 HWND ?
hwndButton3 HWND ?
hwndButton4 HWND ?
hwndButton5 HWND ?
hwndButton6 HWND ?
hwndButton7 HWND ?
hwndButton8 HWND ?
hwndButton9 HWND ?
hwndButton_plus HWND ?
hwndButton_minus HWND ?
hwndButton_times HWND ?
hwndButton_divide HWND ?
hwndButton_equal HWND ?
hwndButton_clear HWND ?
hwndEdit HWND ?
hBitmap dd ?
hScroll HWND ?

.const

IDB_MAIN   equ 1
IDM_TEST equ 1
IDM_HELLO equ 2
IDM_GOODBYE equ 3
IDM_GETTEXT equ 4
IDM_EXIT equ 5
IDM_ABOUT equ 6
IDM_SHOW equ 6

ButtonID0 equ 0
ButtonID1 equ 1
ButtonID2 equ 2
ButtonID3 equ 3
ButtonID4 equ 4
ButtonID5 equ 5
ButtonID6 equ 6
ButtonID7 equ 7
ButtonID8 equ 8
ButtonID9 equ 9
ButtonID_plus equ 10
ButtonID_minus equ 11
ButtonID_times equ 12
ButtonID_divide equ 13
ButtonID_equal equ 14
ButtonID_clear equ 15
EditID equ 2

.code

start:
    mov esi,offset output
    mov addrop,esi
	invoke GetModuleHandle, NULL
	mov    hInstance,eax
	invoke GetCommandLine
	mov    CommandLine,eax
	invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess,NULL

	WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	LOCAL hwnd:HWND

    ; parameters of window_class
	mov   wc.cbSize, SIZEOF WNDCLASSEX
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	mov   wc.cbClsExtra, NULL
	mov   wc.cbWndExtra, NULL
	push  hInstance
	pop   wc.hInstance
	mov   wc.hbrBackground, COLOR_WINDOW+1
	mov   wc.lpszMenuName, OFFSET MenuName
	mov   wc.lpszClassName, OFFSET ClassName

	invoke LoadIcon, NULL, IDI_APPLICATION
	mov   wc.hIcon, eax
	mov   wc.hIconSm, eax
	invoke LoadCursor, NULL, IDC_ARROW
	mov   wc.hCursor, eax
	invoke RegisterClassEx, addr wc

	INVOKE CreateWindowEx,\
          ;ExStyle, pointer of class name, pointer of title name
           NULL,ADDR ClassName,ADDR AppName,\
          ;style, coordinate X of window, coordinate Y of window
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,CW_USEDEFAULT,\
          ;width of window, height of window
           400,600,\
          ;window's parent, handle to the window's menu
           NULL,NULL,\
          ;instance handle, lp parameter
           hInst,NULL
	mov   hwnd, eax

	invoke ShowWindow, hwnd, SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
	.WHILE TRUE
		invoke GetMessage, ADDR msg, NULL, 0, 0
		.BREAK .IF (!eax)
		invoke TranslateMessage, ADDR msg
		invoke DispatchMessage, ADDR msg
	.ENDW

	mov     eax,msg.wParam
	ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

    LOCAL hdc:HDC   ;the handle of device context
    LOCAL hMemDC:HDC
	LOCAL ps:PAINTSTRUCT
	LOCAL hfont:HFONT   ;the handle of font
	LOCAL rect:RECT
	;LOCAL Scroll_rect:RECT

	.if uMsg==WM_DESTROY    ;close window
        invoke DeleteObject,hBitmap
		invoke PostQuitMessage, NULL
    .ELSEIF uMsg==WM_LBUTTONDOWN    ;left mouse button click
		mov eax,lParam
		and eax,0ffffh
		mov hitpoint.x,eax
		mov eax,lParam
		shr eax,16
		mov hitpoint.y,eax
		mov MouseClick,TRUE
		invoke InvalidateRect,hWnd,NULL,TRUE
    .ELSEIF uMsg==WM_CREATE

        invoke LoadBitmap,hInstance,IDB_MAIN
        mov hBitmap,eax
        invoke CreateFont,\
		;height, width, escapement, orientation
		36,16,0,0,\
		;weight, italic, underline, strike out
		400,0,0,0,\
		;charset, output precision, clip precision
		DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,\
		;quality, pitch and family, pointer of font's name
        PROOF_QUALITY,DEFAULT_PITCH or FF_SCRIPT,ADDR FontName
		mov    hfont,eax
        ;edit box
        invoke CreateWindowEx,WS_EX_CLIENTEDGE, ADDR EditClassName,ADDR output,\
                        WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or\
                        ES_AUTOHSCROLL,\
                        50,75,280,50,hWnd,EditID,hInstance,NULL
		mov  hwndEdit,eax
        invoke SendMessage,hwndEdit,WM_SETFONT,hfont,1
		;if click 0
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText0,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        120,425,75,75,hWnd,ButtonID0,hInstance,NULL
		mov  hwndButton0,eax

		;if click 1
        invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText1,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        45,350,75,75,hWnd,ButtonID1,hInstance,NULL
		mov  hwndButton1,eax

		;if click 2
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText2,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        120,350,75,75,hWnd,ButtonID2,hInstance,NULL
		mov  hwndButton2,eax

		;if click 3
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText3,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        195,350,75,75,hWnd,ButtonID3,hInstance,NULL
		mov  hwndButton3,eax

		;if click 4
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText4,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        45,275,75,75,hWnd,ButtonID4,hInstance,NULL
		mov  hwndButton4,eax

		;if click 5
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText5,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        120,275,75,75,hWnd,ButtonID5,hInstance,NULL
		mov  hwndButton5,eax

		;if click 6
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText6,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        195,275,75,75,hWnd,ButtonID6,hInstance,NULL
		mov  hwndButton6,eax

		;if click 7
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText7,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        45,200,75,75,hWnd,ButtonID7,hInstance,NULL
		mov  hwndButton7,eax

		;if click 8
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText8,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        120,200,75,75,hWnd,ButtonID8,hInstance,NULL
		mov  hwndButton8,eax

		;if click 9
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText9,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        195,200,75,75,hWnd,ButtonID9,hInstance,NULL
		mov  hwndButton9,eax

		;if click +
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText_plus,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        270,425,75,75,hWnd,ButtonID_plus,hInstance,NULL
		mov  hwndButton_plus,eax

		;if click -
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText_minus,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        270,350,75,75,hWnd,ButtonID_minus,hInstance,NULL
		mov  hwndButton_minus,eax

		;if click *
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText_times,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        270,275,75,75,hWnd,ButtonID_times,hInstance,NULL
		mov  hwndButton_times,eax

		;if click /
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText_divide,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        270,200,75,75,hWnd,ButtonID_divide,hInstance,NULL
		mov  hwndButton_divide,eax

		;if click =
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText_equal,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        195,425,75,75,hWnd,ButtonID_equal,hInstance,NULL
		mov  hwndButton_equal,eax

		;if click C
		invoke CreateWindowEx,NULL, ADDR ButtonClassName,ADDR ButtonText_clear,\
                        WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
                        45,425,75,75,hWnd,ButtonID_clear,hInstance,NULL
		mov  hwndButton_clear,eax

		invoke SendMessage,hwndButton0,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton1,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton2,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton3,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton4,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton5,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton6,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton7,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton8,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton9,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton_plus,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton_minus,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton_times,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton_divide,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton_equal,WM_SETFONT,hfont,1
		invoke SendMessage,hwndButton_clear,WM_SETFONT,hfont,1

    .ELSEIF uMsg==WM_COMMAND
		mov eax,wParam
		.IF lParam==0
            .IF ax==IDM_ABOUT
                invoke MessageBox, hScroll,ADDR scrtxt, OFFSET AppName,MB_OK
                ;invoke GetClientRect,hScroll,addr Scroll_rect
                ;invoke ScrollWindowEx, hScroll,0,5,addr Scroll_rect,addr Scroll_rect,NULL,NULL,SW_ERASE
            .ELSEIF ax==IDM_HELLO
                invoke MessageBox, NULL,ADDR Hello_string, OFFSET AppName,MB_OK
            .ELSEIF ax==IDM_GOODBYE
                invoke MessageBox,NULL,ADDR Goodbye_string, OFFSET AppName, MB_OK
            .ELSEIF  ax==IDM_GETTEXT
				invoke GetWindowText,hwndEdit,ADDR buffer,512
				invoke MessageBox,NULL,ADDR buffer,ADDR AppName,MB_OK
            .ELSEIF ax==IDM_SHOW
            .ELSE
                invoke DestroyWindow,hWnd
            .ENDIF
        .ELSE
			.IF ax==ButtonID0
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'0'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID1
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'1'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID2
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'2'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID3
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'3'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID4
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'4'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID5
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'5'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID6
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'6'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID7
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'7'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID8
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'8'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID9
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'9'
                    inc esi
                    mov addrop, esi
                    invoke SetWindowText,hwndEdit,ADDR output
				.ENDIF
            .ELSEIF ax==ButtonID_plus
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'+'
                    inc esi
                    mov addrop, esi
                    cmp bo,0
                    je no_plus
                    plus:
                        invoke GetWindowText,hwndEdit,ADDR buffer,32
                        invoke search_string,ADDR buffer
                        invoke String_To_Int,ADDR buffer,ADDR output_int
                        invoke calculate,op,buffer_int,output_int,ADDR output_int
                        .IF clear_bo == 1
                        jmp Clear
                        .EndIF
                        mov op,1
                        push eax
                        mov eax,output_int
                        mov buffer_int,eax
                        pop eax
                        invoke Clear_String,ADDR output
                        invoke Int_To_String,output_int,ADDR output
                        mov esi,addrop
                        mov byte ptr[esi],'+'
                        inc esi
                        mov addrop, esi
                        invoke SetWindowText,hwndEdit,ADDR output
                        jmp plus_jump
                    no_plus:
                        inc bo
                        mov op,1
                        invoke GetWindowText,hwndEdit,ADDR buffer,32
                        invoke String_To_Int,ADDR buffer,ADDR buffer_int
                        invoke Clear_String,ADDR buffer
                        invoke SetWindowText,hwndEdit,ADDR output
                    plus_jump:

				.ENDIF
            .ELSEIF ax==ButtonID_minus
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'-'
                    inc esi
                    mov addrop, esi
                    cmp bo,0
                    je no_minus
                    minus:
                        invoke GetWindowText,hwndEdit,ADDR buffer,32
                        invoke search_string,ADDR buffer
                        invoke String_To_Int,ADDR buffer,ADDR output_int
                        invoke calculate,op,buffer_int,output_int,ADDR output_int
                        .IF clear_bo == 1
                        jmp Clear
                        .EndIF
                        mov op,2
                        push eax
                        mov eax,output_int
                        mov buffer_int,eax
                        pop eax
                        invoke Clear_String,ADDR output
                        invoke Int_To_String,output_int,ADDR output
                        mov esi,addrop
                        mov byte ptr[esi],'-'
                        inc esi
                        mov addrop, esi
                        invoke SetWindowText,hwndEdit,ADDR output
                        jmp minus_jump
                    no_minus:
                        .IF output[0] == "-" && minus_bo == 0
                            mov minus_bo, 1
                            invoke SetWindowText,hwndEdit,ADDR output
                            jmp minus_jump
                        .EndIF
                        inc bo
                        mov op,2
                        invoke GetWindowText,hwndEdit,ADDR buffer,32
                        invoke String_To_Int,ADDR buffer,ADDR buffer_int
                        invoke Clear_String,ADDR buffer
                        invoke SetWindowText,hwndEdit,ADDR output
                    minus_jump:

				.ENDIF
            .ELSEIF ax==ButtonID_times
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'*'
                    inc esi
                    mov addrop, esi
                    cmp bo,0
                    je no_multiple
                    multiple:
                        invoke GetWindowText,hwndEdit,ADDR buffer,32
                        invoke search_string,ADDR buffer
                        invoke String_To_Int,ADDR buffer,ADDR output_int
                        invoke calculate,op,buffer_int,output_int,ADDR output_int
                        .IF clear_bo == 1
                        jmp Clear
                        .EndIF
                        mov op,3
                        push eax
                        mov eax,output_int
                        mov buffer_int,eax
                        pop eax
                        invoke Clear_String,ADDR output
                        invoke Int_To_String,output_int,ADDR output
                        mov esi,addrop
                        mov byte ptr[esi],'*'
                        inc esi
                        mov addrop, esi
                        invoke SetWindowText,hwndEdit,ADDR output
                        jmp multiple_jump
                    no_multiple:
                        inc bo
                        mov op,3
                        invoke GetWindowText,hwndEdit,ADDR buffer,32
                        invoke String_To_Int,ADDR buffer,ADDR buffer_int
                        invoke Clear_String,ADDR buffer
                        invoke SetWindowText,hwndEdit,ADDR output
                    multiple_jump:

				.ENDIF
            .ELSEIF ax==ButtonID_divide
				shr eax,16
				.IF ax==BN_CLICKED
                    mov esi, addrop
                    mov byte ptr[esi],'/'
                    inc esi
                    mov addrop, esi
                    cmp bo,0
                    je no_divide
                    divide:
                        invoke GetWindowText,hwndEdit,ADDR buffer,32
                        invoke search_string,ADDR buffer
                        invoke String_To_Int,ADDR buffer,ADDR output_int
                        invoke calculate,op,buffer_int,output_int,ADDR output_int
                        .IF clear_bo == 1
                        jmp Clear
                        .EndIF
                        mov op,4
                        push eax
                        mov eax,output_int
                        mov buffer_int,eax
                        pop eax
                        invoke Clear_String,ADDR output
                        invoke Int_To_String,output_int,ADDR output
                        mov esi,addrop
                        mov byte ptr[esi],'/'
                        inc esi
                        mov addrop, esi
                        invoke SetWindowText,hwndEdit,ADDR output
                        jmp divide_jump
                    no_divide:
                        inc bo
                        mov op,4
                        invoke GetWindowText,hwndEdit,ADDR buffer,32
                        invoke String_To_Int,ADDR buffer,ADDR buffer_int
                        invoke Clear_String,ADDR buffer
                        invoke SetWindowText,hwndEdit,ADDR output
                    divide_jump:
				.ENDIF

            .ELSEIF ax==ButtonID_equal
				shr eax,16
				.IF ax==BN_CLICKED
                    invoke GetWindowText,hwndEdit,ADDR buffer,32
                    invoke search_string,ADDR buffer
                    invoke String_To_Int,ADDR buffer,ADDR output_int
                    invoke calculate,op,buffer_int,output_int,ADDR output_int
                    .IF clear_bo == 1
                        jmp Clear
                    .EndIF
                    invoke Clear_String,ADDR output
                    invoke Int_To_String,output_int,ADDR output
                    invoke SetWindowText,hwndEdit,ADDR output
                    mov op,0
                    mov bo,0
				.ENDIF
            .ELSEIF ax==ButtonID_clear
				shr eax,16
				.IF ax==BN_CLICKED
Clear:
                    mov op,0
                    mov bo,0
                    mov minus_bo,0
                    mov clear_bo,0
                    invoke Clear_String,ADDR output
                    invoke Clear_String,ADDR buffer
                    invoke SetWindowText,hwndEdit,ADDR output
                    mov esi,offset output
                    mov addrop, esi
				.ENDIF
			.ENDIF
		.ENDIF
    .ELSEIF uMsg==WM_PAINT
		invoke BeginPaint,hWnd, ADDR ps
		mov    hdc,eax
		invoke CreateCompatibleDC,hdc
        mov hMemDC,eax
        invoke SelectObject,hMemDC,hBitmap
        invoke GetClientRect,hWnd,addr rect
        ;invoke BitBlt,hdc,0,0,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY
        invoke BitBlt,hdc,0,0,400,600,hMemDC,0,0,SRCCOPY
        invoke DeleteDC,hMemDC
		;.IF MouseClick
        ;invoke TextOut,\
		;handle of device context, coord.X, coord.Y, pointer of string, sizeof string
		;hdc,240,35,ADDR output,SIZEOF output
		;.endif
		invoke EndPaint,hWnd, ADDR ps
	.else
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam
		ret
	.endif

	xor eax,eax
	ret
WndProc endp

String_To_Int proc, pString: PTR byte, pint: ptr sdword
    LOCAL sign_bool:byte
    push eax
    push ecx
    push edx
    push esi
    mov edx, pString ; our string
    mov esi, pint
    mov sign_bool, 0
    .IF byte ptr[edx] == '-'
        mov sign_bool, 1
        inc edx
    .EndIF
    atoi:
    xor eax, eax ; zero a "result so far"
    top:
    movzx ecx, byte ptr[edx] ; get a character
    inc edx ; ready for next one
    cmp ecx, '0' ; valid?
    jb done
    cmp ecx, '9'
    ja done
    sub ecx, '0' ; "convert" character to number
    imul eax, 10 ; multiply "result so far" by ten
    add eax, ecx ; add in current digit
    jmp top ; until done
    done:
    .IF sign_bool == 1
    sub eax, 1
    and eax, eax
    not eax
    .EndIF
    mov [esi],eax
    pop esi
    pop edx
    pop ecx
    pop eax
    ret
String_To_Int endp

Int_To_String proc, stringify_int: sdword, pString: ptr byte

    printNumber:
        push eax
        push ebx
        push edx
        push esi
        push edi
        mov eax, stringify_int
        mov esi, pString
        mov edi, pString
        mov ebx,offset divisor
    .IF stringify_int == 0
        mov byte ptr[esi],'0'
        inc esi
        jmp IfZero
    .EndIF
    .IF stringify_int < 0
        mov byte ptr[esi],'-'
        inc esi
        mov eax, stringify_int     ;negative to positive
        not eax
        and eax, eax
        add eax, 1
    .EndIF
    nextDigit:
        xor edx,edx          ;edx:eax = number
        div dword ptr[ebx]      ;eax = quotient, edx = remainder
        add eax,'0'
        .IF eax=='0'
            .IF boo==1
                mov [esi],al
                inc esi
            .ENDIF
        .ELSE
        mov boo,1
        mov [esi],al
        inc esi      ;Display the quotient
        .ENDIF
        mov eax,edx          ;eax = remainder
        add ebx,4            ;ebx = address of next divisor
        cmp dword ptr[ebx],0    ;Have all divisors been done?
        jne nextDigit
    IfZero:
        mov boo,0
        mov addrop,esi
        push edi
        push esi
        pop edx
        pop ebx
        pop eax
        ret
Int_To_String endp

Clear_String PROC, pString: ptr byte
    mov esi,pString
    push eax
    push edx
    .While TRUE
    mov eax, [esi]
        .Break .IF(eax == 0)
        mov byte ptr[esi], 0
    add esi, 1
    .EndW
    mov edx, OFFSET output
    pop edx
    pop eax
    ret
Clear_String ENDP

search_string proc string:ptr byte
    push ecx
    push edi
    push esi
    push ebx
    mov esi,string
    inc esi
    mov edi,string
    search:
        test byte ptr[esi],00010000b
        jz break_label
        inc esi
        jmp search
    break_label:
    inc esi
    sub esi,edi
    mov ecx,esi
    mov esi,string
    add esi,ecx
    mov ecx, 16
    cld
    rep movsb
    mov byte ptr[edi],0
    pop ebx
    pop esi
    pop edi
    pop ecx
    ret
search_string endp

calculate proc operator:byte, buffer_num:sdword, output_num:sdword, result_num:ptr dword
    LOCAL temp:dword
    push eax
    push ebx
    push esi
    push edi
    mov esi,result_num
    mov edi,buffer_num
    operation_2:
    .IF operator==1
        add edi, output_num
        mov dword ptr[esi],edi
    .ELSEIF operator==2
        sub edi, output_num
        mov dword ptr[esi],edi
    .ELSEIF operator==3
        mov eax, buffer_num
        mov ebx, output_num
        imul ebx
        mov dword ptr[esi],eax
    .ELSEIF operator==4
        mov eax, buffer_num
        cdq
        mov ebx, output_num
        .IF output_num == 0
            mov eax, 0
            mov clear_bo, 1
            invoke MessageBox, NULL,ADDR Warn_string, OFFSET AppName,MB_OK
            jmp cant_divide
        .EndIF
        idiv ebx
cant_divide:
        mov dword ptr[esi],eax
    .ENDIF
    pop edi
    pop esi
    pop ebx
    pop eax
    ret
calculate endp
end start
