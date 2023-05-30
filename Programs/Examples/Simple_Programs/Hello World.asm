; COM file is loaded at CS:0100h
;  program prints a message to the dos console

mov ah, 0Eh
; while ah = 0Eh, int 10h prints the value of al to the console
mov si,0  ; start outputting at byte [0] of the message
start:           
   mov al, message[si]     ; move the character that will be outputted into al
   int 10h                 ; output the character 
   inc si                  ; add 1 to si to go to the next character in the next pass
   or al,al
jne start ; loop through the characters of the message while al is not 0 


RET ; exit and return to dos

message db 'Hello, World!', 0
; the message that is shown ending which is null terminating (ends with 0)
