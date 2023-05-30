; COM file is loaded at CS:0100h
;  program prints a message to the dos console

org 100h

mov dx, offset InputMessage ; dx = the address of the message to output
mov ah, 09h 
int 21h           ; while ah = 09h, int21h outputs a '$' terminating string from address DX to the console

mov ah,01h
mov si,0 ; start character

InputLoop: 
     int 21h ; get inputted character from user and store it in AL register
     mov byte[si+InputBuffer], al
     cmp al,13 ; 13 = the enter character
     je EndOfInput 

     inc si ; go to next character
     mov bl,byte[si+Password]
     or bl,bl
     jz EndOfInput  ; at the end of the password, jump to the end of the input loop
     jmp InputLoop

EndOfInput:
mov ah,0Eh
mov al,13
int 10h
mov al,10
int 10h
; now it is on the next line.   

; now to check if there is a match
mov si,0
CheckChar:
       mov al,Password[si]
       cmp InputBuffer[si],al
       jne NoMatch ; jump if the 2 characters are not the same
       or al,al
       jz Match ; reaches the end of the password with all characters matching
       inc si
       jmp CheckChar
       
Match:
       mov dx, offset PWCorrectMSG ; dx = the address of the message to output
       mov ah, 09h 
       int 21h           ; while ah = 09h, int21h outputs a '$' terminating string from address DX to the console
       jmp END

NoMatch:
       mov dx, offset PWIncorrectMSG ; dx = the address of the message to output
       mov ah, 09h 
       int 21h           ; while ah = 09h, int21h outputs a '$' terminating string from address DX to the console

END:

RET ; exit and return to dos

InputMessage db 'Please type the password: $'

Password db 'right', 0 ; a null terminating password

InputBuffer db 0,0,0,0,0,0,0,0,0,0 ; some space to temperarily store the inputted string
; this must be the same length as the password or longer.

PWCorrectMSG db 'You typed the right password.$'

PWIncorrectMSG db 'You typed the wrong password.$'
