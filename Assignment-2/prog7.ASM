.model small

.stack 100h

.data
	m1 db 1,0,1,0,1,0,1,0,1
	m2 db -2,3,-4,1,8,-2,4,6,5
	m3 db 9 dup(0)
	msg db "Product matrix: ",0ah,0dh,"$"
	nl db 0ah,0dh,'$'
	space db " $"
	three db 03h
	startvar dw 00h
	endvar dw 03h
	row db 00h
	mulval db ?

.code
main proc far
	mov ax, @data
	mov ds, ax

	lea dx, msg
	mov ah, 09h
	int 21h
	
	call multiply_matrices

	call print_matrix

	mov ah, 4ch
	int 21h
	
main endp

multiply_matrices proc
	mov ch, 00h
	
	outer_loop_i:
	cmp ch, 03h		; ch = i
	jz exit_outer_loop_i
	mov cl, 00h
	inner_loop_j:
	cmp cl, 03h		; cl = j
	jz exit_inner_loop_j
	mov dl, 00h
	inner_loop_k:
	cmp dl, 03h		; dl = k
	jz exit_inner_loop_k
	mov al, ch
	mul three
	add al, dl
	mov bx, ax
	mov dh, m1[bx]
	mov al, dl
	mul three
	add al, cl
	mov bx, ax
	mov ah, m2[bx]
	mov mulval, ah
	xor ah, ah
	mov al, dh
	imul mulval
	mov dh, al
	mov al, ch
	mul three
	add al, cl
	mov bx, ax
	add m3[bx], dh
	inc dl
	jmp inner_loop_k
	exit_inner_loop_k:
	inc cl
	jmp inner_loop_j
	exit_inner_loop_j:
	inc ch
	jmp outer_loop_i
	exit_outer_loop_i:
	ret	
multiply_matrices endp

print_matrix proc
	mov startvar, 00h
	mov endvar, 03h

	matrix_print:
	cmp row, 03h
	jz exit_matrix_print

	call print_array
	
	add startvar, 03h
	add endvar, 03h
	inc row
	jmp matrix_print
	
	exit_matrix_print:
	ret
print_matrix endp

print_array proc	; starting index should be stored in si, ending index in some variable
	mov si, startvar

	arr_print:
	xor cx, cx
	mov cl, m3[si]
	call print_num

	inc si
	
	lea dx, space
	mov ah, 09h
	int 21h

	cmp si, endvar
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

	print_zero:
	cmp cl, 00h
	js print_neg
	jnz push_num

	xor dx,dx
	add dx,30h

	mov ah,02h
	int 21h
	jmp exit_print

	print_neg:
	mov dx, 2dh 	; "-" ascii
	mov ah, 02h
	int 21h
	neg cl
	xor ax, ax
	mov al, cl
	
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