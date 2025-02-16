
; *************************************************************************
; 32-bit Windows Console Hello World Application - MASM32 Example
; EXE File size: 2,560 Bytes
; Created by Visual MASM (http://www.visualmasm.com)
; *************************************************************************
                                    
.386					; Enable 80386+ instruction set
.model flat, stdcall	; Flat, 32-bit memory model (not used in 64-bit)
option casemap: none	; Case insensitive syntax

; *************************************************************************
; MASM32 proto types for Win32 functions and structures
; *************************************************************************  
include c:\masm32\include\windows.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
include c:\masm32\include\msvcrt.inc
include c:\masm32\include\masm32rt.inc
         
; *************************************************************************
; MASM32 object libraries
; ************************z*************************************************  
includelib c:\masm32\lib\windows.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib
includelib c:\masm32\lib\msvcrt.lib
includelib c:\masm32\lib\masm32rt.lib

; *************************************************************************
; Our data section. Here we declare our strings for our message
; *************************************************************************

extern _kbhit : PROC
extern _getch : PROC

.data
	infmt byte "%d",0
	msgfmt byte "%s", 0
	espacio byte " ",0
	p1C byte "*", 0
	cls2 byte "cls", 0 
	pared byte "x", 0
	juegoterminado byte "Has chocado ! Perdiste!", 0
	obsinfo byte 0Ah, "Obstaculo_info: [%d, %d] | [%d, %d] | [%d, %d] | [%d, %d]",0
	obsinforandom byte 0Ah, "Random_info: x_distance = %d | y_distance = %d", 0
	
	xlim sdword 85
	ylim sdword 23
	
	ob1_x1 sdword 5
	ob1_y1 sdword 5
	ob1_x2 sdword 0
	ob1_y2 sdword 0
	ob1_x3 sdword 0
 	ob1_y3 sdword 0
 	ob1_x4 sdword 0
	ob1_y4 sdword 0
	
	ob2_x1 sdword 30
	ob2_y1 sdword 5
	ob2_x2 sdword 0
	ob2_y2 sdword 0
	ob2_x3 sdword 0
 	ob2_y3 sdword 0
 	ob2_x4 sdword 0
	ob2_y4 sdword 0
	
	ob1x_distance sdword 5
	ob1y_distance sdword 5
	
	ob2x_distance sdword 5
	ob2y_distance sdword 5	
	
	xp sdword 0
	yp sdword 0
	dir sdword ?
	tecla byte ?

	ms1 sdword 100
	
	IZQ equ 0
 	DER equ 1
 	ARRIBA equ 2
 	ABAJO equ 3
 	
 	IZQ_T equ 97
 	DER_T equ 100
 	ARRIBA_T equ 119
 	ABAJO_T equ 115
 	
 	i sdword 0
 	seed dd 0
 	
 	info byte "x = %d | y = %d | dir = %d", 0
	
; *************************************************************************
; Our executable assembly code starts here in the .code section
; *************************************************************************

.code


start:
	invoke crt_system, addr cls2
	mov ebx, ARRIBA
	mov dir, ebx
	
	mov eax, xlim
	mov ecx, 2
	cdq
	idiv ecx
	mov ebx, eax
	
	mov xp, ebx
	
	mov eax, ylim
	mov ecx, 2
	cdq
	idiv ecx
	mov ebx, eax	
	mov yp, ebx


	;Dibujar tablero
	mov ebx, xlim
	mov i, ebx
	
	repeat01:
		mov ebx, ylim
		invoke locate, i, 0
		invoke crt_printf, addr pared
		invoke locate, i, ebx
		invoke crt_printf, addr pared
		
		cmp i, 0
		je endrepeat01
		dec i
		jmp repeat01
	endrepeat01:	nop

	mov ebx, ylim
	mov i, ebx

	repeat02:
		mov ebx, xlim
		invoke locate, 0, i
		invoke crt_printf, addr pared
		invoke locate, ebx, i
		invoke crt_printf, addr pared
		
		cmp i, 0
		je endrepeat02
		dec i
		jmp repeat02
	endrepeat02:	nop

;Generar obstaculos
		invoke GetTickCount
	    mov [seed], eax
	    mov eax, [seed]
	    xor edx, edx  ; Limpia EDX para la divisi n
	    mov ecx, 9   ; Rango deseado (0 a 8)
	    div ecx       ; EDX:EAX / ECX = EAX (resto en EDX)
	    add edx, 3    ; Ajusta el rango a 2-10
			
		mov ob1x_distance, edx
			
	    mov [seed], eax
	    mov eax, [seed]
	    xor edx, edx  ; Limpia EDX para la divisi n
	    mov ecx, 9   ; Rango deseado (0 a 8)
	    div ecx       ; EDX:EAX / ECX = EAX (resto en EDX)
	   	add edx, 3    ; Ajusta el rango a 2-10
			
		mov ob1y_distance, edx	
	    mov [seed], eax
	    mov eax, [seed]
	    xor edx, edx  ; Limpia EDX para la divisi n
	    mov ecx, 9   ; Rango deseado (0 a 8)
	    div ecx       ; EDX:EAX / ECX = EAX (resto en EDX)
	    add edx, 3    ; Ajusta el rango a 2-10
			
		mov ob2x_distance, edx			
	    mov [seed], eax
	    mov eax, [seed]
	    xor edx, edx  ; Limpia EDX para la divisi n
	    mov ecx, 9   ; Rango deseado (0 a 8)
	    div ecx       ; EDX:EAX / ECX = EAX (resto en EDX)
	    add edx, 3    ; Ajusta el rango a 2-10
			
		mov ob2y_distance, edx

		

  	;Calculo de coordenadas
  	;Coordenadas en X del objeto 1
  	mov ebx, ob1_x1
	mov ob1_x2, ebx
	mov ob1_x4, ebx  	
  	mov ob1_x3, ebx
  	mov ebx, ob1x_distance
  	add ob1_x2, ebx
  	add ob1_x4, ebx
  	
  	;Coordenadas en X del objeto 2
  	mov ebx, ob2_x1
	mov ob2_x2, ebx
	mov ob2_x4, ebx  	
  	mov ob2_x3, ebx
  	mov ebx, ob2x_distance
  	add ob2_x2, ebx
  	add ob2_x4, ebx	
  	
  	;Coordenadas en Y del objeto 1
  	mov ebx, ob1_y1
	mov ob1_y2, ebx
	mov ob1_y4, ebx  	
  	mov ob1_y3, ebx
  	mov ebx, ob1y_distance
  	add ob1_y3, ebx
  	add ob1_y4, ebx   	
  	
  	mov ebx, ob2_y1
	mov ob2_y2, ebx
	mov ob2_y4, ebx  	
  	mov ob2_y3, ebx
  	mov ebx, ob2y_distance
  	add ob2_y3, ebx
  	add ob2_y4, ebx 
  	
  	
  	invoke locate,xlim,ylim
  	invoke crt_printf, addr obsinforandom, ob1x_distance, ob1y_distance
  	invoke crt_printf, addr obsinforandom, ob2x_distance, ob2y_distance
  	invoke crt_printf, addr obsinfo, ob1_x1, ob1_y1, ob1_x2, ob1_y2, ob1_x3, ob1_y3, ob1_x4, ob1_y4
  	invoke crt_printf, addr obsinfo, ob1_x1, ob1_y1, ob1_x2, ob1_y2, ob1_x3, ob1_y3, ob1_x4, ob1_y4
  	
  	mov ebx, ob1_x1
  	mov i, ebx
  	dibujo_obs1_x:	
  	
  			invoke locate, i, ob1_y1
  			invoke crt_printf, addr pared
  			invoke locate, i, ob1_y3
  			invoke crt_printf, addr pared
  			
  			mov ebx, ob1_x2
  			inc i
  			cmp i, ebx
  			jg end_obs1_x
  			
			jmp dibujo_obs1_x
	end_obs1_x:	nop
	
  	mov ebx, ob1_y1
  	mov i, ebx	
	
    dibujo_obs1_y:  
    
            invoke locate, ob1_x1, i
            invoke crt_printf, addr pared
            invoke locate, ob1_x2, i
            invoke crt_printf, addr pared
            
            mov ebx, ob1_y3
            inc i
            cmp i, ebx
            jg end_obs1_y
            
            jmp dibujo_obs1_y
    end_obs1_y: nop
	


  	mov ebx, ob2_x1
  	mov i, ebx
  	dibujo_obs2_x:	
  	
  			invoke locate, i, ob2_y1
  			invoke crt_printf, addr pared
  			invoke locate, i, ob2_y3
  			invoke crt_printf, addr pared
  			
  			mov ebx, ob2_x2
  			inc i
  			cmp i, ebx
  			jg end_obs2_x
  			
			jmp dibujo_obs2_x
	end_obs2_x:	nop
	
  	mov ebx, ob2_y1
  	mov i, ebx	
	
    dibujo_obs2_y:  
    
            invoke locate, ob2_x1, i
            invoke crt_printf, addr pared
            invoke locate, ob2_x2, i
            invoke crt_printf, addr pared
            
            mov ebx, ob2_y3
            inc i
            cmp i, ebx
            jg end_obs2_y
            
            jmp dibujo_obs2_y
    end_obs2_y: nop
			
	while01:
	
	
		invoke locate, xp, yp
		invoke crt_printf, addr espacio

 		; Llama a kbhit para verificar si se ha presionado una tecla
	    call _kbhit
	    test eax, eax            ; Comprueba si se ha presionado una tecla
	    jz no_key
		; Llama a getch para obtener la tecla presionada
	    call _getch
	    mov tecla, al
	    
		movzx ebx, al
		;invoke crt_printf, addr infmt, tecla
		switch01:		cmp ebx, IZQ_T
						je caseIZQ_T 
						cmp ebx, DER_T
					 	je caseDER_T
					 	cmp ebx, ARRIBA_T
						je caseARRIBA_T
						cmp ebx, ABAJO_T
						je caseABAJO_T
						jmp endswitch01
		caseIZQ_T:
			mov ebx, IZQ
			mov dir, ebx
			jmp endswitch01	
		caseDER_T:
			mov ebx, DER
			mov dir, ebx
			jmp endswitch01
		caseARRIBA_T:
			mov ebx, ARRIBA
			mov dir, ebx
			jmp endswitch01
		caseABAJO_T:
			mov ebx, ABAJO
			mov dir, ebx
			jmp endswitch01
		endswitch01:	nop		
		
		no_key:
		mov ebx, dir
		switch02:		cmp ebx, IZQ
						je caseIZQ02
						cmp ebx, DER
					 	je caseDER02
					 	cmp ebx, ARRIBA
						je caseARRIBA02
						cmp ebx, ABAJO
						je caseABAJO02
						jmp endswitch02
		caseIZQ02:
			dec xp
			jmp endswitch02
		caseDER02:
			inc xp
			jmp endswitch02
		caseARRIBA02:
			dec yp
			jmp endswitch02
		caseABAJO02:
			inc yp
			jmp endswitch02
		endswitch02:	nop
		  
		
		;Colision con los bordes
		mov ebx, xlim
		.if xp <= 0
			jmp endwhile01
		.endif
		.if xp >= ebx
			jmp endwhile01
		.endif
		mov ebx, ylim
		.if yp <= 0
			jmp endwhile01
		.endif
		.if yp >= ebx
			jmp endwhile01
		.endif
		
		;Colision con los obstaculos
		mov ebx, xp
		mov eax, yp
        .if ebx >= ob1_x1 && ebx <= ob1_x2 && eax >= ob1_y1 && eax <= ob1_y3
            jmp endwhile01
        .endif
        .if ebx >= ob2_x1 && ebx <= ob2_x2 && eax >= ob2_y1 && eax <= ob2_y3
            jmp endwhile01
        .endif
		
		
		invoke locate, xp, yp
		
		invoke crt_printf, addr msgfmt, addr p1C
		
		mov ebx, ylim
		add ebx, 5
		invoke locate, 0, ebx
		invoke crt_printf, addr info, xp, yp, dir
		invoke Sleep, ms1
		
		jmp while01
	endwhile01: 	nop
	mov ebx, ms1
	imul ebx, 10
	invoke Sleep, eax
	
	invoke crt_system, addr cls2
	
	invoke crt_printf, addr juegoterminado

	; When the console has been closed, exit the app with exit code 0
    invoke ExitProcess, 0
end start
