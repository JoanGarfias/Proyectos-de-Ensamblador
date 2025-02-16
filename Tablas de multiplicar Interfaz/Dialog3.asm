.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc


.Data?
	buffer db 512 dup(?)
	bufferaux db 512 dup(?)
	bufferFinal db 512 dup (?)

.Data
	Label1 equ 1000
	tablaInput equ 1001
	okBtn equ 1002
	tablaLabel equ 1003
	
	stringFormat byte "%dx%d=%d", 0Ah, 0
	

	num sdword ?
	i sdword 1
.Code

WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
	.IF uMsg==WM_DESTROY
		invoke PostQuitMessage,NULL
	.ELSEIF uMsg==WM_COMMAND
		mov eax,wParam
		.IF lParam==0
			; Process messages, else...
			invoke DestroyWindow,hWnd
		.ELSE
			mov edx,wParam
			shr edx,16
			.IF edx == BN_CLICKED
				switch01:	
					cmp eax, okBtn
					je case01
					jmp default01
				case01:
					invoke GetDlgItemText, hWnd, tablaInput, addr buffer, 512
					invoke crt_atoi, addr buffer
					mov num, eax		
					
					while01:    
								mov ebx, 10	
								cmp i, ebx
								jg endwhile01
									
								mov eax, num
				    			imul i      	; eax tiene el resultado
				    			mov edx, num	; edx tiene el numero
				    			
								mov ebx, i
				    			
								mov edi, OFFSET bufferaux
				    			invoke wsprintf, edi, OFFSET stringFormat, edx, ebx, eax   ; Llama a wsprintf para convertir el número en una cadena
								
    							invoke lstrcat, ADDR bufferFinal, ADDR bufferaux
								
									
								inc i
				    			jmp while01
					endwhile01:		nop
					
					invoke GetDlgItem, hWnd, tablaLabel
					invoke SetWindowText, eax, OFFSET bufferFinal
					
					; Llenar el buffer con valores nulos
			        xor al, al ; Valor nulo (0)
			        mov edi, OFFSET bufferFinal ; Puntero al inicio del buffer
			        mov ecx, SIZEOF bufferFinal; Tamaño del buffer en bytes
			        rep stosb ; Llenar el buffer con valores nulos
					
					mov i, 1		
				default01:
				endswitch01:	nop
				
			.ENDIF
			; Process messages here
		.ENDIF
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.ENDIF
	xor	eax,eax
	ret
WndProc endp

end
