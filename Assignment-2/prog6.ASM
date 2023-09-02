.model small

.stack 100h

.data
	m dw 001ah	
	n dw 0022h	
	gcd dw 0000h
	no1 db "m = $"
	no2 db ", n = $"
	gcd_msg db "GCD: $"
	nl db 0ah, 0dh, "$"
	
.code
main proc far
	mov ax, @data
	mov ds, ax

	lea dx, no1
	mov ah, 09h
	int 21h
	
	mov cx, m
	call print_num
	
	lea dx, no2
	mov ah, 09h
	int 21h

	mov cx, n
	call print_num
	
	lea dx, nl
	mov ah, 09h
	int 21h

	call find_gcd
	; gcd stores the gcd
	
	lea dx, gcd_msg
	mov ah, 09h
	int 21h

	mov cx, gcd
	call print_num

	mov ah, 4ch
	int 21h	
main endp

find_gcd proc	;modifies cx, ax, dx, gcd
	;if m%n == 0 return n
	;else return gcd(n, m%n)
	mov ax, m
	mov cx, n
	xor dx, dx
	
	gcd_find:
	cmp cx, 00h
	jz exit_gcd

	div cx	; ax / cx(operand) = quotient [dx ax], remainder [dx]

	mov ax, cx
	mov cx, dx
	xor dx, dx
	jmp gcd_find

	exit_gcd:
	mov gcd, ax
	ret	
find_gcd endp

print_num proc ; prints num stored in cx, modifies ax, di, cl, dx, dx
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