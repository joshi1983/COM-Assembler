; program outputs about 16 000 ! characters in a loop

mov ah, 0Eh
mov al, '!' ; move the value that will be outputted
mov cx, 7FFFh ; set the number of times the character will be outputted

start:
   int 10h ; output the character
   loopnz start ; if cx is not 0, keep looping

ret ; exit the program and return to DOS