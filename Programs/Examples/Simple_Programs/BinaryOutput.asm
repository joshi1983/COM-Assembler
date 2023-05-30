;  program outputs a value from bl as binary 8 digits

mov ah, 0Eh
; while ah = 0Eh, int 10h prints the value of al to the console

mov bl, 101b ; set the value of bl that will be shown on the screen
mov cl, 8 ; set the number of passes for the loop

OutputChar:

  mov al, bl    ; move the current value of bl into al
  and al,1      ; mask out all binary digits except the lowest order bit 
  add al,'0'     ; add the ascii value of '0' to al so if al was 1 before, now it is '1' and if it was just zero before, it becomes '0'
  int 10h        ; output the binary digit
  shr bl,1       ; shift all the binary digits in bl to the right by 1 
  dec cl        ; subtract 1 from cl to count the number of passes in the loop 
  or cl,cl
  jne OutputChar   ; keep looping while cl is not 0 

RET ; exit and return to dos
