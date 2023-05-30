; input example gets 1 character of input from the user and outputs it to the console

mov ah,09h
mov dx,offset msg1
int 21h  ; output the enter input message
mov ah,01h
int 21h	; wait for a character to be inputted into al

sub al,'0' ; subtract the ascii value of '0' to get the numarical value
// for (bx=al; bx!=0; bx--)
//      al*=x;
// bx = al
and ax,ffh ; ax = al
mov bx,ax ; bx = al
dec al

StartLoop:
	mul bx,ax	   
	dec al
	jnz StartLoop


ret ; exit and return to DOS

PrintAL:
	mov ah,0
	//div ah,


msg1 db 'enter a digit to find its factorial:  $'