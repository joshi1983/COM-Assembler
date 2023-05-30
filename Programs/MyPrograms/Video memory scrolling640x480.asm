;  program writes data directly to video memory(a lot more efficiently than with the SetPixel interrupt)
; for more information on writing to video memory, go to the web address below.
; http://www.codepedia.com/1/x86ASMFAQ_Graphics

; The difference between this and the other video memory program is this puts the frame writing code inside another loop that changes the initial colour by 1 with each pass.

mov ax,0012h ; video mode 12h which is Graphics    16 colour palette     640x480 pixels    
int 10h ; set the video mode
; look in Help -> Getting Started for a link to an explanation of various video modes.


mov bl,ffh

DrawFrame:
	mov al,bl ; set initial al value(colour value)

	mov dx, 479 ; y-coordinate
	mov cx, 320; initial x-coordinate

                mov ax, A001h
                mov es,ax  ; video memory starts at A000:0000h in display mode 12h but the screen takes a little more than 10000h so es needs to be initialized 1 larger than normal and decremented.
	mov di, 64000 ; number of bytes (640*480)
	PixelLoop:

     		dec di    ; subtract 1 from di to get the next byte/pixel in video memory
     		mov byte ptr[es:di], al  ; move the value into memory
   		loopnz PixelLoop ; Decrement cx.  If cx is not 0, jump to PixelLoop.

                cmp di,320
                jg NoSegmentUpdate
                    mov cx,es
                    dec cx
                    mov es,cx
                    mov di,FFFFh

                NoSegmentUpdate:
	inc al ; add 1 to the colour
	mov cx,320 ; right of page 640 pixels * 4 bits/pixel * byte/(8 bits) = 320 bytes 
	dec dx
	or dx,dx
	jne PixelLoop

dec bl ; decrease the initial colour by 1
jmp DrawFrame

RET ; exit and return to dos