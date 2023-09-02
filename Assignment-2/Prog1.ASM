.model small
.stack 100h
.data
	arr db 0fh,1fh,0dh,0dh,0eh,0bh,0bh,1bh,0ch,3fh
	count equ 0ah
	msg1 db "ARRAY IS: $"
	msg2 db "SMALLEST NUMBER IS: $"
	space db " $"
	nl db 0ah,0dh,'$'
	idx dw ?
	min db ?
.code
main proc far
	mov ax, @data
	mov ds, ax
	
	mov si, offset arr
	mov bl, [si]
	mov cx, count
	
	find_min:
	cmp bl, [si]
	jle increment_si
	
	update_min:
	mov bl, [si]

	increment_si:
	inc si
	loop find_min

	mov min,bl

	call print_array

	lea dx,msg2
	mov ah,09h
	int 21h

	xor cx,cx
	mov cl,min
	call print_num

	mov ah,4ch
	int 21h
main endp

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
	
	
	
	
	
	
	