.model small

.stack 40h

.data
	msg1 db "LENGTH OF PARAMETERS: $"
	msg2 db "PARAMETERS: $"
	nl db 0ah,0dh,"$"

.code
main proc far
	mov bx, ds	; initially DS stores PSP
	mov es, bx	; transferring PSP to ES
	
	mov ax, @data
	mov ds, ax

	lea dx, msg1
	mov ah, 09h
	int 21h
	
	xor cx, cx
	mov cl, byte ptr es:[80h]	; getting length of parameter string
	mov dx, cx
	mov ah, 02h
	add dx, 30h	
	dec dx			; not counting space in front "_2 3" 
	int 21h

	lea dx, nl
	mov ah, 09h
	int 21h

	lea dx, msg2
	mov ah, 09h
	int 21h

	mov si, ds		; moving data segment to SI
	mov di, es		; moving PSP (in ES) to DI
	mov ds, di		; moving contents of DI (PSP) to DS

	mov ah, 40h		; write to
	mov bx, 01h		; standard output
	mov dx, 82h		; the parameter string w/o the space in front
	int 21h	
	
	exit:
	mov ah, 4ch
	int 21h
main endp
end main