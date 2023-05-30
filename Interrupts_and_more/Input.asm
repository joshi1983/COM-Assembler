; input example gets 1 character of input from the user and outputs it to the console

mov ah,09h
mov dx,offset msg1
int 21h  ; output the enter input message
mov ah,01h
int 21h	; wait for a character to be inputted into al

ret ; exit and return to DOS

msg1 db 'enter input:  $'