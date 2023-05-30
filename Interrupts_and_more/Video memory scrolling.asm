;  program writes data directly to video memory(a lot more efficiently than with the SetPixel interrupt)
; for more information on writing to video memory, go to the web address below.
; http://www.codepedia.com/1/x86ASMFAQ_Graphics

; The difference between this and the other video memory program is this puts the frame writing code inside another loop that changes the initial colour by 1 with each pass.

mov ax,0013h ; video mode 13h which is Graphics     256 colour palette     320x200 pixels    
int 10h ; set the video mode
; look in Help -> Getting Started for a link to an explanation of various video modes.


mov ax, A000h
mov es,ax  ; video memory starts at A000:0000h in display mode 13h

mov bl,ffh

DrawFrame:
	mov al,bl ; set initial al value(colour value)

	mov dx, 199 ; y-coordinate
	mov cx, 320; initial x-coordinate

	mov di,0 ; number of bytes (320*200)
	PixelLoop:
                               
                                stosb
   		loop PixelLoop ; Decrement cx.  If cx is not 0, jump to PixelLoop.

	inc al ; add 1 to the colour
	mov cx,320 ; right of page
	dec dx
	jnz PixelLoop
                

dec bl ; decrease the initial colour by 1
jmp DrawFrame

RET ; exit and return to dos