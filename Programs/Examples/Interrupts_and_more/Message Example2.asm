; COM file is loaded at CS:0100h
;  program prints a message to the dos console by directly accessing the memory
; There is another example in the simple programs folder that does much the same using interrupts.

mov ax,B800h
mov es,ax ; set the segment register to the video memory location
; in video mode 3(the initial video mode), the video memory starts at B800:0000

mov ah, 0Eh
; while ah = 0Eh, int 10h prints the value of al to the console
mov si,0  ; start outputting at byte [0] of the message

start:           
   mov al, message[si]     ; move the character that will be outputted into al
   mov di,si
   shl di,1 ; There are 2 bytes to each character in the display so multiply DI by 2
   mov [es:di],al ; output the byte to video memory
   inc si                  ; add 1 to si to go to the next character in the next pass
   or al,al ; if al=0,  the zero flag is set.
jnz start ; loop through the characters of the message while al is not 0 

RET ; exit and return to dos

message: 

db 'No program made because there was no instructions to assemble.', 13, 10 
; The 13 and 10 ended the lines when we used the interrupt, however here these just make weird characters. 

db 'This is an automatically generated program.',0 ; 0 is used to mark the end of the message.

; There is the message to be shown on the screen.