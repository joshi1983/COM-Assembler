;  program writes data directly to video memory(a lot more efficiently than with the SetPixel interrupt)
; for more information on writing to video memory, go to the web address below.
; http://www.codepedia.com/1/x86ASMFAQ_Graphics

mov ax,0013h ; video mode 13h which is Graphics     256 colour palette     320x200 pixels    
int 10h ; set the video mode
; look in Help -> Getting Started for a link to an explanation of various video modes.


mov ax, A000h
mov es,ax  ; video memory starts at A000:0000h in display mode 13h

mov al,0 ; initial colour value
mov cx,00C8h ; 200 rows
here2: 
mov dx,cx
mov cx,0140h ; 320 columns
here1:
mov ah,0Ch 
int 10h ; go to it
inc al ; increment colour value
loop here1
mov cx,dx
loop here2 ; next row

RET ; exit and return to dos