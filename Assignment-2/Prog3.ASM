.model small
.stack 100h
.data
	arr db 0fh,1fh,0dh,0dh,0eh,0bh,0bh,1bh,0ch,3fh
	count equ 0ah
	msg1 db "ARRAY BEFORE SORTING IS: $"
	msg2 db "ARRAY AFTER SORTING IS: $"
	space db " $"
	nl db 0ah,0dh,'$'
	temp db ?
	idx dw ?
.code
main proc far
	mov ax, @data
	mov ds, ax
	mov cx, count

	lea dx,msg1
	mov ah,09h
	int 21h

	call print_array

	call bubble_sort

	lea dx,msg2
	mov ah,09h
	int 21h

	call print_array

	mov ah,4ch
	int 21h
main endp

bubble_sort proc
	mov si, offset arr ; &arr[0]
	mov ax, 00h  ;i
	mov cx, 00h  ;j
	
	outer_loop:
	cmp ax, count
	jz exit_bsort	

	mov cx, 00h
	mov si, offset arr

	inner_loop:
	cmp cx, 09h
	jz incr_outer_loop_idx

	mov bl, [si]
	inc si
	cmp bl, [si]
	jnle incr_inner_loop_idx
	
	swap:
	mov bh, bl
	mov bl, [si]
	mov [si], bh

	dec si
	mov [si],bl
	inc si
	
	incr_inner_loop_idx:
	inc cx
	jmp inner_loop

	incr_outer_loop_idx:
	inc ax
	jmp outer_loop	

	exit_bsort:
	ret
bubble_sort endp

print_array proc
	mov di,count
	mov si, offset arr
	
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
	
	
	
	
	
	
	