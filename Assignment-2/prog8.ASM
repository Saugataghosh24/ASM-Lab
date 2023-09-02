.model small

.stack 100h

.data
	bcdstr db 8 dup(0)
	two db 02h
	prompt1 db "ENTER THE BINARY NUMBER: $"
	prompt2 db "ENTER THE BINARY CODED DECIMAL: $"
	msg1 db "BINARY CODED DECIMAL: $"
	msg2 db "BINARY NUMBER: $"
	space db " $"
	nl db 0ah,0dh,"$"
	twopow db 80h
	num db 00h
	ten db 0ah
	temp dw ?

.code
main proc far
	mov ax, @data
	mov ds, ax

	binary_to_bcd:
	lea dx, prompt1
	mov ah, 09h	
	int 21h
	
	call bintodec

	lea dx, nl
	mov ah, 09h
	int 21h
	
	call dectobcd

	lea dx, msg1
	mov ah, 09h
	int 21h

	call print_bcd

	lea dx, nl
	mov ah, 09h
	int 21h

	bcd_to_binary:
	lea dx, prompt2
	mov ah, 09h	
	int 21h
	
	call read_bcd

	lea dx, nl
	mov ah, 09h
	int 21h

	call bcd_to_dec

	lea dx, msg2
	mov ah, 09h
	int 21h

	xor ax, ax
	mov al, num
	call dectobin

	mov ah, 4ch
	int 21h	
main endp

bintodec proc		; end result: num stores decimal rep of 8bit binary
	mov cx, 08h

	check_twopow:
	cmp cx, 00h
	jz exit_bintodec

	read:
	mov ah, 01h ;set AL to read a character
	int 21h

	cmp al, 0dh
	jz exit_bintodec

	dec cx

	sub al, 30h
	cmp al, 00h
	jz dec_twopow

	add_twopow:
	mov bh, twopow
	add num, bh

	dec_twopow:
	xor ax, ax
	mov al, twopow
	div two
	mov twopow, al

	jmp check_twopow  

	exit_bintodec: 
	ret
bintodec endp

dectobcd proc		; prerequisites: decimal value stored in num
	mov al, num
	mov si, 07h
	
	loop_divten:
	cmp al, 00h
	jz exit_dectobcd

	xor ah, ah
	div ten
	
	mov temp, ax
	mov dl, ah
	
	call dectobin_digit

	mov ax, temp		; al stores the current number
	jmp loop_divten

	exit_dectobcd:
	ret
dectobcd endp

dectobin_digit proc		; prereq: decimal digit stored in dl
	mov cl, 00h
	mov al, dl

	loop_bin:
	cmp al, 00h
	jz check_length

	xor ah, ah
	div two
	
	xor dx, dx
	mov bcdstr[si], ah
	dec si
	
	inc cl
	jmp loop_bin		
	
	check_length:
	cmp cl, 04h
	jz exit_dectobin_digit

	mov bcdstr[si], 00h
	dec si
	
	inc cl
	jmp check_length

	exit_dectobin_digit:
	ret
dectobin_digit endp
	
print_bcd proc		
	xor dx, dx
	mov si, 00h

	loop_printdigit:
	cmp si, 08h
	jz exit_printbcd

	mov dl, bcdstr[si]
	inc si

	add dx, 30h
	mov ah, 02h
	int 21h

	check_for_fourth:
	cmp si, 04h
	jnz jump_loop

	lea dx, space
	mov ah, 09h
	int 21h

	jump_loop:
	jmp loop_printdigit
	
	exit_printbcd:
	ret
print_bcd endp

read_bcd proc
	mov cx, 08h
	mov ah, 01h
	mov si, 00h
	
	read_digit:
	int 21h
	cmp al, 0dh
	jz exit_readbcd

	sub al, 30h
	mov bcdstr[si], al
	inc si
	loop read_digit

	exit_readbcd:
	ret	
read_bcd endp

bcd_to_dec proc		; bcd rep in bcdstr and num will store decimal rep
	mov si, 00h
	mov temp, 04h
	xor cx, cx
	mov num, 00h
	
	first_digit:
	call bcd_to_decimal	
	
	mov ch, cl
	cmp ch, 00h
	jz next_digit

	mov al, ch
	mul ten
	add num, al

	next_digit:
	mov temp, 08h
	call bcd_to_decimal
	add num, cl

	exit_bcdtodec:
	ret
bcd_to_dec endp

bcd_to_decimal proc	; converts 4bit bcd to decimal digit
	mov twopow, 08h
	mov cl, 00h
	
	check_twopow_bcd:
	cmp si, temp
	jz exit_bcdtodecimal

	cmp bcdstr[si], 00h
	jz dec_twopow_bcd

	add_twopow_bcd:
	mov bh, twopow
	add cl, bh

	dec_twopow_bcd:
	xor ax, ax
	mov al, twopow
	div two
	mov twopow, al

	inc si

	jmp check_twopow_bcd

	exit_bcdtodecimal:
	ret
bcd_to_decimal endp

dectobin proc		; ax stores the decimal number
	mov cx,00h   ;count variable
	mov dx,00h   ;stores remainder after division

	cmp ax,00h
	jz printzero_bin
	
	bin_loop:
	cmp ax,00h
	jz check_length_bin

	mov bx,02h
	div bx

	push dx
	inc cx

	mov dx,00h
	jmp bin_loop

	check_length_bin:
	mov temp, 08h
	sub temp, cx	; temp contains no. of leading zeroes (if any)

	print_leading_zeroes:
	cmp temp, 00h
	jz printbin
	
	mov dx, 30h
	mov ah, 02h
	int 21h

	dec temp
	jmp print_leading_zeroes

	printbin:
	cmp cx,00h
	jz exit_bin
	pop dx

	add dx,30h
	mov ah,02h
	int 21h

	dec cx
	jmp printbin

	printzero_bin:
	mov dx,00h
	add dl,30h
	mov ah,02h
	int 21h

	exit_bin:
	ret
dectobin endp

end main