;  program writes data directly to video memory(a lot more efficiently than with the SetPixel interrupt)
; for more information on writing to video memory, go to the web address below.
; http://www.codepedia.com/1/x86ASMFAQ_Graphics

mov ax,0013h ; video mode 13h which is Graphics     256 colour palette     320x200 pixels    
int 10h ; set the video mode
; look in Help -> Getting Started for a link to an explanation of various video modes.


mov ax, A000h
mov es,ax  ; video memory starts at A000:0000h in display mode 13h

mov dx, 199 ; y-coordinate
mov cx, 320; initial x-coordinate
mov al,2

mov di, 64000 ; number of bytes (320*200)
PixelLoop:

     dec di    ; subtract 1 from di to get the next byte/pixel in video memory
     mov byte ptr[es:di], al  ; move the value into memory
   loopnz PixelLoop ; Decrement cx.  If cx is not 0, jump to PixelLoop.

inc al ; add 1 to the colour
mov cx,320 ; right of page
dec dx
or dx,dx
jne PixelLoop


RET ; exit and return to dos