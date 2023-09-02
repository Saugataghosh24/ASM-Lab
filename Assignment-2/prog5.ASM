.model small

.stack 100h

.data
	num dw 00h
	rev_num dw 00h
	dummy dw 00h
	prompt db "Enter a number: $"
	pal db "Palindrome.$",0dh, 0ah
	not_pal db "Not a palindrome.$",0dh,0ah

.code
main proc far
	mov ax, @data
	mov ds, ax

	lea dx, prompt 
	mov ah, 09h
	int 21h

	call read_num	; now num stores number

	call reverse_num	; now rev_num stores reverse of number
	
	mov cx, num
	cmp cx, rev_num
	jz palindrome
	jnz not_palindrome

	palindrome:
	lea dx, pal
	mov ah, 09h
	int 21h
	jmp exit_main

	not_palindrome:
	lea dx, not_pal
	mov ah, 09h
	int 21h
	
	exit_main:
	mov ah, 4ch
	int 21h
main endp

read_num proc	; modifies cx, ax, dx, bl (possibly) and num(data segment)
	mov cl, 0ah

	read:
	mov ah, 01h
	int 21h

	cmp al, 0dh
	jz exit_read_num

	sub al, 30h
	mov bl, al
	xor bh, bh
	xor ah, ah
	mov ax, num
	
	mul cl ; ax * cl (operand) = [ax]
	mov num, ax
	
	add num, bx
	jmp read

	exit_read_num:
	ret
read_num endp

reverse_num proc	; modifies ax, bx, dx, cx, rev_num (data segment), dummy (data segment)
	mov ax, num
	mov cx, 0ah

	reverse:
	cmp ax, 00h
	jz exit_reverse_num
	xor dx, dx	; clearing the dx register which will store the reaminder
	
	div cx	; ax / cx (operand) = quotient: [dx ax] (supposedly), remainder: dx

	mov dummy, ax
	mov bx, dx
	mov ax, rev_num

	mul cx	; ax * cx (operand) = [dx ax]
	
	add ax, bx
	mov rev_num, ax

	mov ax, dummy
	jmp reverse

	exit_reverse_num:
	ret
reverse_num endp

end main


	



	
	
	


	

	
	
	
	