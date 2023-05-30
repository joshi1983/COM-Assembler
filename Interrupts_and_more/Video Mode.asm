; COM file is loaded at CS:0100h
;  program prints a message to the dos console

mov ah,00h
mov al,13h ; video mode 13h which is Graphics     256 colour palette     320x200 pixels    
int 10h ; set the video mode

; AH = 0Ch 
; AL = Pixel Value 
; If bit 7 is set, then value is XOR-ed (not in 256 color mode) 
; BH = Page Number 
; CX = Pixel Column 
; DX = Pixel Row 

mov ah,0Ch 
mov dx, 199  ; initial y-coordinate 
mov cx, 319 ; x-coordinate
mov al, 2 ; pixel value/colour
mov bh, 0 ; page number

PixelLoop:
   int 10h   ; set the pixel
   loopnz PixelLoop ; Decrement cx.  If cx is not 0, jump to PixelLoop.

inc al ; add 1 to the colour
mov cx,319 ; right of page
dec dx
or dx,dx
jne PixelLoop


RET ; exit and return to dos
