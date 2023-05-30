; COM file is loaded at CS:0100h
;  program prints a message to the dos console

mov dx, offset message ; DS : DX = the address of the message to output
mov ah, 09h 
int 21h           ; while ah = 09h, int21h outputs a '$' terminating string from address DX to the console

ret ;  exit and return to DOS

message db 'Hello, World!$'
; the message to be shown
