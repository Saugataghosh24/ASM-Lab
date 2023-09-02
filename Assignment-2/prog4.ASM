.model small
.stack 100h
.data
	str1 db 50 dup('$')
	str2 db 50 dup('$')
	msg1 db "ENTER A STRING: $"
	msg2 db "STRINGS IN DICT. STYLE: $"
	space db ", $"
	nl db 0ah,0dh,'$'
	firststr dw ?
	secondstr dw ?
.code
main proc far
	mov ax, @data
	mov ds, ax

	call input_string

	call sort_str

	lea dx,msg2
	mov ah,09h
	int 21h

	call print_str

	mov ah,4ch
	int 21h
main endp

input_string proc
	prompt1:
	lea dx,msg1
	mov ah,09h	
	int 21h
	
	init1:
	mov bl, 00h
        lea si, str1    ;load address to source index (SI)
	mov ah, 01h    ;set AL to read a character

        read1:
	int 21h
	cmp al, 0dh    ;check if ENTER key has been pressed
	jz prompt2    

        mov [si], al   ;else move the character to current index of SI
        inc si	      ;increment SI
	inc bl
                
        jmp read1      ;read a character again

	prompt2:
	lea dx,msg1
	mov ah,09h	
	int 21h

	init2:
	mov bh, 00h
        lea si, str2    ;load address to source index (SI)
	mov ah, 01h    ;set AL to read a character

        read2:
	int 21h
	cmp al, 0dh    ;check if ENTER key has been pressed
	jz exit_printstr    	

        mov [si], al   ;else move the character to current index of SI
        inc si	      ;increment SI
	inc bh
                
        jmp read2      ;read a character again

	exit_printstr:
	lea dx, nl
	mov ah, 09h
	int 21h 
	ret
input_string endp

sort_str proc
	mov si, offset str1  ; str1.size() in bl
	mov di, offset str2  ; str2.size() in bh
	mov firststr, offset str1
	mov secondstr, offset str2
	mov cl, 00h  ; idx of str1
	mov ch, 00h  ; idx of str2
	
	outer_loop:
	cmp cl, bl
	jz exit_bsort	

	cmp ch, bh
	jz exit_bsort

	mov dl, [si]
	cmp [di], dl
	jz incr_idx

	jnle exit_bsort

	mov ax, firststr
	mov cx, secondstr
	mov firststr, cx
	mov secondstr, ax

	jmp exit_bsort
	
	incr_idx:
	inc si
	inc di
	inc cl
	inc ch 
	jmp outer_loop

	exit_bsort:
	ret
sort_str endp

print_str proc
	mov dx, firststr
	mov ah, 09h
	int 21h

	lea dx, space
	mov ah, 09h
	int 21h 

	mov dx, secondstr
	mov ah, 09h
	int 21h 

	ret
print_str endp

end main
	
	
	
	
	
	
	