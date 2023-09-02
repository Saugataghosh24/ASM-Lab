.model small
.stack 100h
.data
str db 30 dup('$')
inp db 'Enter a string : $'

.code
main proc far
mov ax,@data
mov ds,ax
lea si,str
l1:
mov ah,01h
int 21h
cmp al,13
je l2
mov [si],al
inc si
jmp l1
l2:
lea dx,str
mov ah,09h
int 21h
mov ah,4ch
int 21h
main endp
end main