; COM file is loaded at CS:0100h
;  program prints a message to the dos console

mov ah,00h
mov al,13h ; video mode 13h which is Graphics     256 colour palette     320x200 pixels    
int 10h ; set the video mode

mov ax, A000h
mov es,ax  ; video memory starts at A0000h in this display mode

; AH = 0Ch 
; AL = Pixel Value 
; If bit 7 is set, then value is XOR-ed (not in 256 color mode) 
; BH = Page Number 
; CX = Pixel Column 
; DX = Pixel Row 

mov ah,0Ch 
mov dx, 99 ; y-coordinate
mov cx, 319; initial x-coordinate
mov al, 2 ; pixel value/colour
mov bh, 0 ; page number

mov di, 3200 ; number of bytes in 

PixelLoop:

     dec di
     mov byte ptr[es:di], al  ; move the value into memory
     int 10h
   loopnz PixelLoop ; Decrement cx.  If cx is not 0, jump to PixelLoop.

inc al ; add 1 to the colour
mov cx,319 ; right of page
dec dx
or dx,dx
jne PixelLoop


RET ; exit and return to dos

