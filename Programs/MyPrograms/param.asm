; This sample prints out the command
; line parameters.
; In DOS you simply add this line
; after an executable:
; param.com my parameters
; In emulator you should set
; them by selecting "Set command line paramters"
; from "File" menu of emulator window.

#make_COM#

ORG     100h


; address of command line:
MOV     SI, 80h


; copy command line to our buffer:
XOR     CX, CX          ; zero CX register.
MOV     CL, [SI]        ; get command line size.

mov    DI, offset buffer      ; load buffer address to DI.

CMP     CX, 0           ; CX = 0 ?
JZ      no_param        ; then skip the copy.

INC     SI              ; copy from second byte.
next_char:
MOV     AL, [SI]
MOV     [DI], AL
INC     SI
INC     DI
LOOP    next_char

; set '$' sign in the end of the buffer:
MOV     BYTE PTR [DI], '$'

; print out the buffer:
mov     DX, offset buffer
MOV     AH, 09h
INT     21h

JMP     exit    ; skip error message.

no_param:
; print out the error message:
mov     DX, offset msg
MOV     AH, 09h
INT     21h
JMP     exit

; exit here:
exit:
RET

buffer DB '                              '
msg DB 'No command line parameters!', 13, 10, '$'

END
