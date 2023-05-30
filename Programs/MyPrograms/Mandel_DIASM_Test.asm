; program: C:\Downloads\ASM\fasm144\mandel.com
; disassembled with MyAssembler

mov ax, 0013h
int 10h
push A000h
pop es
mov dx, 03C8h
xor al, al
out dx, al
inc dl
mov cx, 0040h

vga_palette:
   out dx, al
   out dx, al
   out dx, al
   inc al
   loop vga_palette ; E2F9

   xor di, di ; 31FF
   xor dx, dx ; 31D2

; -------- this is where things screw up --------------

   wait 			; 9B
   fninit 			; DBE3
   fld QWORD PTR [BP+01ABh] 	; D906AB01
   fstp QWORD PTR [BP+01BBh] 	; D91EBB01
   xor bx, bx
   fld QWORD PTR [BP+01A7h]
   fstp QWORD PTR [BP+01B7h]
   wait
   fninit
   fldz
   fldz
   mov cx, 003Fh
   fld st0
; disassembling process incomplete because of an error

; The rest of the program will use a hex dump.
db D8h,C8h,D9h,C9h,D8h,CAh,D8h,C0h
db D9h,CAh,D8h,C8h,DEh,E9h,D9h,C9h
db D8h,06h,BBh,01h,D9h,C9h,D8h,06h
db B7h,01h,D9h,C1h,D8h,C8h,D9h,C1h
db D8h,C8h,DEh,C1h,D9h,FAh,DFh,1Eh
db BFh,01h,83h,3Eh,BFh,01h,02h,77h
db 02h,E2h,CBh,88h,C8h,AAh,D9h,06h
db B7h,01h,D8h,06h,AFh,01h,D9h,1Eh
db B7h,01h,43h,81h,FBh,40h,01h,72h
db ABh,D9h,06h,BBh,01h,D8h,26h,B3h
db 01h,D9h,1Eh,BBh,01h,42h,81h,FAh
db C8h,00h,72h,8Eh,30h,E4h,CDh,16h
db B8h,03h,00h,CDh,10h,CDh,20h,CDh
db CCh,0Ch,C0h,00h,00h,A0h,3Fh,9Ah
db 99h,19h,3Ch,CDh,CCh,4Ch,3Ch,
