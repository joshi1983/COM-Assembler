;  program writes data directly to video memory(a lot more efficiently than with the SetPixel interrupt)
; for more information on writing to video memory, go to the web address below.
; http://www.codepedia.com/1/x86ASMFAQ_Graphics

mov ax,0013h ; video mode 13h which is Graphics     256 colour palette     320x200 pixels    
int 10h ; set the video mode
; look in Help -> Getting Started for a link to an explanation of various video modes.


mov ax, A000h
mov es,ax  ; video memory starts at A000:0000h in display mode 13h

mov di,0
mov cx,FA00h ; 320 X 200
mov al,0 ; initial colour
here:
   stosb ; write pixel
   inc al ; increment the colour
   loop here


RET ; exit and return to dos