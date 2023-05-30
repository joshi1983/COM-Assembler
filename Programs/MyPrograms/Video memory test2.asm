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

mov bx, 99 ; y-coordinate
mov ax, 319; initial x-coordinate
mov cl, 2 ; pixel value/colour


;ax=x, bx=y cl=color es=0xA000
putPixel:
    mov di, bx      ;di=bx
    shl bx, 6       ;bx=bx*64
    shl di, 8       ;di=di*256
    add di, bx      ;di=di+bx (or bx*64+bx*256 which is bx*320)
    add di, ax      ;di=x+y*320
    mov [es:di], cl ;store the pixel




    ret             ;that's all

 

