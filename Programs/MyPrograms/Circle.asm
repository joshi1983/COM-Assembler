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
mov al,8

finit ; initialize FPU

; loop dx up from the bottom
;    - calculate start x coordiante of circle
;    - calculate end of circle
;    - loop through those pixels
;      -  - set byte/colour
YLoop:
      fldz
      fild word[YPosition]
      fmul st0,st0  ; square the value     
      fchs             ; change sign to negative
      fiadd  word[RadiusSquared]
      fcomi st0,st2
      jnc SkipRow
               fsqrt
               fist word[Length]
               fchs
               fiadd word[HalfWidth] 
               fistp word[XPosition]               

              mov cx,word[Length]
               shl cx,1
               mov si,dx
               shl si,2
               add si,dx
               shl si,6    ; si = dx*320
               add si,word[XPosition]
               DrawRowLoop:
                          ; dx*320 + cx+word[XPosition]
                          mov es:[si], al
                          inc si
                        loopnz DrawRowLoop
      SkipRow:
       fstp st0

dec dx
mov word[YPosition], dx
jnz YLoop


RET ; exit and return to dos

Length dw 0
XPosition dw 0
YPosition dw 199
RadiusSquared dw 10000
HalfWidth dw 100