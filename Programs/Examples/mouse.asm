; copyright 2003 Dreq
; all rights reserved

mov ah, 0		;func 0h (set video mode)
mov al, 13h		;mode 13h (320x200x256)
int 10h			;ms-dos graphics

mov ax, 0		;func 0h (reset mouse)
int 33h			;ms-dos mouse
mov ax, 20h		;enable mouse driver
int 33h
mov ax, 1		;func 1h (show mouse cursor)
int 33h

mov ax, 0Ch		;func Ch (subroutine called on mouse click)
mov dx, click		;label to jump to on mouse click (im not sure about how to type that part ;)
mov cx, 8 		;user interrupt mask 0000 1000 (left button down)
int 33h

loop:
jmp loop

click:

mov ah, 0		;func 0h (set video mode)
mov al, 1		;mode 1h (text 40x25)
int 10h			;ms-dos graphics