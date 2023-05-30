; This sample shows the
; use of a timer function
; (INT 15h / 86h)
; This code prints some chars
; with 1 second delay.

#make_COM#

ORG     100h

; set the segment register,
; just in case:
MOV     AX, CS
MOV     DS, AX

next_char:

CMP   byte ptr[count], 0
JZ      stop

; print char:
MOV     AL, [c1]
MOV     AH, 0Eh
INT     10h

; next ascii char:
INC    byte [c1]
DEC    byte [count]

; set interval (1 million
; microseconds - 1 second):
MOV     CX, 0Fh
MOV     DX, 4240h
MOV     AH, 86h
INT     15h

; stop any error:
JC      stop    

JMP     next_char

stop:
RET

count:   DB      10
c1:      DB      'A'

END
