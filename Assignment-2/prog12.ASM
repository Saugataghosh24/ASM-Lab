.model small

.stack 40h

.data
	msg1 db "NUMBER OF COLUMNS: $"
	msg2 db "NUMBER OF ROWS: $"
	prompt db "PRESS ANY KEY.$"
	nl  db 0ah, 0dh, "$"

.code
main proc far
	mov ax, @data
	mov ds, ax

	lea dx, msg1
	mov ah, 09h
	int 21h

	mov ah, 0fh	; get current video mode
			; al = video mode
			; ah = no. of char cols per line
			; bh = active display page number
	int 10h

	mov cl, ah
	call print_num

	lea dx, nl
	mov ah, 09h
	int 21h

	lea dx, msg2
	mov ah, 09h
	int 21h

	mov ah, 03h	; get current cursor position
			; dh = row, dl = col
	int 10h
	
	mov cl, dh
	inc cl		; cl contained row - 1
	call print_num

	lea dx, nl
	mov ah, 09h
	int 21h

	lea dx, prompt
	mov ah, 09h
	int 21h

	mov ah, 01h	; waits for keypress
	int 21h

	mov al, 00h	; page number
	mov ah, 07h	; scroll down / clear
	mov bh, 07h	; normal attr.
	mov ch, 00h	; rowval of start pt
	mov cl, 00h	; colval of start pt
	mov dh, 18h	; rowval of end pt
	mov dl, 4fh	; colval of end pt
	int 10h

	exit:
	mov ah, 4ch
	int 21h
main endp

print_num proc ; prints num stored in cl
	xor ax,ax
	mov al,cl
	mov di,00h
	mov bl,0ah
	
	push_num:
	cmp al,00h
	jz pop_num

	div bl
	xor dx,dx
	mov dl,ah
	push dx ; remainder after dividing by 10
	
	inc di
	xor ah,ah
	
	jmp push_num

	pop_num:
	cmp di,00h
	jz exit_print

	pop dx
	dec di
	
	add dx,30h
	mov ah,02h
	int 21h
	
	jmp pop_num

	exit_print:
	ret
print_num endp

end main