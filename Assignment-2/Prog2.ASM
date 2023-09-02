.model small
.stack 100h
.data
	arr db 0fh,1fh,0dh,0dh,0eh,0bh,0bh,1bh,0ch,3fh
	count equ 0ah
	prompt db "ENTER ELEMENT TO SEARCH: $"
	msg1 db "ARRAY IS: $"
	msg_found db "FOUND AT: $"	
	msg_notfound db "ELEMENT NOT FOUND.",0dh,0ah,'$'
	nl db 0ah,0dh,'$'
	val db ?
	pos dw ?
	idx dw ?
	space db " $"
	
.code
main proc far
	mov ax, @data
	mov ds, ax
	
	mov dx, offset prompt
	mov ah,09h
	int 21h

	mov ah,01h
	int 21h
	sub al,30h
	mov bl,al
	
	mov ah,01h
	int 21h
	xor bh,bh

	cmp al,0ah
	jz call_search

	sub al,30h
	mov bh,al

	convert_num:
	; bh:bl is 2 digit number
	mov cl,0ah
	mov al,bh
	xor ah,ah
	
	mul cl

	xor bh,bh
	add bx,ax

	;now bx stores the value to be searched for

	lea dx, nl
	mov ah, 09h
	int 21h

	call_search:
	call search

	mov ah,4ch
	int 21h
main endp

search proc
	mov si, 00h
	mov cx,count
	mov di, offset arr
	
	loop_arr:
	mov dx,[di]
	cmp bl,dl
	jz found

	inc si
	inc di
	loop loop_arr

	;search finished

	call print_array

	not_found:
	lea dx, msg_notfound
	mov ah, 09h
	int 21h
	jmp exit_search

	found:
	mov pos,si
	call print_array
	lea dx,msg_found
	mov ah,09h
	int 21h

	mov si,pos
	add si,01h
	xor dx,dx
	mov dx,si
	add dx,30h
	mov ah,02h
	int 21h

	lea dx,nl
	mov ah,09h
	int 21h
	
	exit_search:
	ret
search endp	

print_array proc
	mov di,count
	mov si, offset arr

	lea dx,msg1
	mov ah,09h
	int 21h
	
	arr_print:
	xor cx,cx
	mov cl,[si]
	mov idx,di
	call print_num

	inc si
	mov di,idx
	
	lea dx,space
	mov ah,09h
	int 21h

	dec di
	cmp di,00h
	jnz arr_print

	endl:
	lea dx, nl
	mov ah, 09h
	int 21h

	ret
print_array endp

print_num proc ; prints num stored in cx
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