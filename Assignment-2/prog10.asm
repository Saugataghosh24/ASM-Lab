.model small

.stack 100h

.data
	word1 	dw 	1f20h
	word2 	dw 	22ffh
	ptr1	dw	?
	ptr2 	dw	?
	msg1 	db	"NUMBER 1: $"
	msg2	db	", NUMBER 2: $"
	bfswp	db	"BEFORE SWAP, $"
	afswp	db	"AFTER SWAP, $"
	nl	db 	0ah,0dh,'$'

.code
main proc far
	mov ax, @data
	mov ds, ax

	lea dx, word1
	mov ptr1, dx
	lea dx, word2
	mov ptr2, dx

	lea dx, bfswp
	mov ah, 09h
	int 21h

	lea dx, msg1
	int 21h

	mov bx, [ptr1]
	mov ax, [bx]
	call dectohex
	
	lea dx, msg2
	mov ah, 09h
	int 21h
	
	mov bx, [ptr2]
	mov ax, [bx]
	call dectohex

	lea dx, nl
	mov ah, 09h
	int 21h

	push ptr2
	push ptr1

	call swap

	add sp, 06h

	lea dx, afswp
	mov ah, 09h
	int 21h

	lea dx, msg1
	int 21h

	mov bx, [ptr1]
	mov ax, [bx]
	call dectohex
	
	lea dx, msg2
	mov ah, 09h
	int 21h
	
	mov bx, [ptr2]
	mov ax, [bx]
	call dectohex

	lea dx, nl
	mov ah, 09h
	int 21h

	mov ah, 4ch
	int 21h
main endp

swap proc
	push bp
	mov bp, sp
	mov si, word ptr [bp+4]		;addr of word1
	mov di, word ptr [bp+6]		;addr of word2

	mov ptr1, di
	mov ptr2, si
	
	mov sp, bp
	pop bp
	ret
swap endp

dectohex proc
    	mov cx,00h   ;count variable
    	mov dx,00h   ;stores remainder after division
	mov bx,10h

    	cmp ax,00h
    	jz printzero_hex
    
    	hex_loop:
    	cmp ax,00h
    	jz printhex

    	div bx

    	push dx
    	inc cx

    	mov dx,00h
    	jmp hex_loop

    	printhex:
    	cmp cx,00h
    	jz exit_hex

    	pop dx

    	cmp dx, 09h
    	jnle letter 

    	number:
    	add dx,30h
    	mov ah,02h
    	int 21h
    	jmp decr_cx

    	letter:
    	add dl, 37h
    	mov ah,02h
    	int 21h

    	decr_cx:
    	dec cx
    	jmp printhex

    	printzero_hex:
    	mov dx,00h
    	add dl,30h
    	mov ah,02h
    	int 21h

    	exit_hex:
	ret
dectohex endp

	
end main
	 

; Low            |====================|
; addresses      | Unused space       |
;                |                    |
;                |====================|    ← SP points here
;    ↑           | Function's         |
;    ↑           | local variables    |
;    ↑           |                    |    ↑ BP - x
; direction      |--------------------|    ← BP points here
; of stack       | Original/saved BP  |    ↓ BP + x
; growth         |--------------------|
;    ↑           | Return pointer     |
;    ↑           |--------------------|
;    ↑           | Function's         |
;                | parameters         |
;                |                    |
;                |====================|
;                | Parent             |
;                | function's data    |
;                |====================|
;                | Grandparent        |
; High           | function's data    |
; addresses      |====================|