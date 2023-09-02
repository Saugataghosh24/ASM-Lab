.model small  
.stack 100h

.data  
	msg1 db "SUM = $"
 	op1 dd 12345678h  
 	op2 dd 0ffffffffh                                                            
 	ans dd ?
.code  
      	mov     ax, @data  
      	mov     ds, ax  
	mov 	si, 0000h
      	mov     ax, word ptr op1          ; lsb of number1 in ax   
      	mov     bx, word ptr op1+2        ; msb of number1 in bx   
      	mov     cx, word ptr op2          ; lsb of number2 in cx  
      	mov     dx, word ptr op2+2        ; msb of number2 in dx                 
      	add     ax, cx                    ; add msb + msb + carry  
	adc	bx, dx
	adc	si, 00h

      	mov     word ptr ans, ax          ; lsb answer  
      	mov     word ptr ans+2, bx        ; msb answer  
	cmp	si, 0000h
	jz	print_32

	lea	dx, msg1
	mov 	ah, 09h
	int	21h

	mov 	dl, 31h
	mov	ah, 02h
	int 	21h
	
print_32:
      	mov     bx, word ptr ans+2        ; Result in reg bx  
      	mov     dh, 02h  
 l1:    
	mov     ch, 04h                ; Count of digits to be displayed  
      	mov     cl, 04h                   ; Count to roll by 4 bits  
 l2:     
	rol     bx, cl                 ; roll bl so that msb comes to lsb   
      	mov     dl, bl                    ; load dl with data to be displayed  
      	and     dl, 0fH                   ; get only lsb  
      	cmp     dl, 09                    ; check if digit is 0-9 or letter A-F  
      	jbe     l4  
      	add     dl, 37h                    ; if letter add 37H else only add 30H  
 l4:  
	add     dl, 30H  
      	mov     ah, 02H                    ; INT 21H (Display character)  
      	int     21H  
      	dec     ch                        ; Decrement Count  
      	jnz     l2   
      	dec     dh  
      	cmp     dh, 00h  
      	mov     bx, word ptr ans           ; display lsb of answer  
      	jnz     l1  
      	mov     ah, 4ch                   ; Terminate Program  
      	int     21h  
end 