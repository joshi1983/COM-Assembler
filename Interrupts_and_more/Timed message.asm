;  program prints a message to the dos console, each character outputted with a short delay

mov si,0 ; initial character in the message

start:
   mov ah,0Eh 
   ; while ah = 0Eh, int 10h prints the value of al to the console
   mov al, [si+message] ; move the letter H into al
   int 10h       ; output al to the screen

   mov ah,2Ch
   int 21h ; call the get time interrupt
   ; Return: CH = hour CL = minute DH = second DL = 1/100 seconds
   mov [second],dl ; store the second
   SecLoop:
        mov ah,2Ch
        int 21h ; call the get time interrupt

        cmp [second],dl 
        jz SecLoop ; if the second has not changed, keep looping

inc si
or byte[si+message],0 ; if the next character in the message is 0, the zero flag will be set.
jnz start        ; keep looping through the message until the null character is reached.

RET ; exit and return to dos

second db 0

message db 'Hello, this is a timed message.  It uses a short delay between each character.',0
