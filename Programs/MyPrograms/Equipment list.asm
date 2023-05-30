; program checks equipment information
; This program still isn't working right.  I think the value of AX is being changed.


int 11h ; get equipment list and store the flags in AX

; mov ax,FFFFh

push ax		; make sure this value is always kept in memory.
mov cx,16	; The number of flags to check
mov si,-1	; 1 character before the flag statements

LoopFlags: ; loop through each flag and its statement 

	; loop to 
	WriteFlagStatement:
		inc si	
		mov ah,0Eh			
		mov al,FlagStatements[si]	; move a letter from the statement into al
		int 10h 			; output the character
		or al,al
		jnz WriteFlagStatement		; keep looping until the null terminating character

	pop ax	; get the old value of AX back that contains the equipment flags
	mov dx,ax ; store the value of AX into DX
	shr ax,1 ; shift digits to the right by 1 digit
	push ax ; push the new shifted value onto the stack
	
	and dx,1 ; mask downto the current flag 
	or dx,dx
	jz installmessage ; If the flag is 0, jump to set the instal message for outputting. 

		mov dx,offset NotInstalled ; executed if the flag bit is 1(off)
		jmp OutputMessage
	InstallMessage:
		mov dx,offset Installed  ; executed if the flag bit is 0(on)

	OutputMessage:
		mov ah, 09h 
		int 21h   ; output the message ' was installed' or ' was not installed'    	

	dec cx
	or cx,cx
	jne LoopFlags   ; keep looping through the flags until they are done and CX is 0

pop ax
RET ; exit and return to dos

;=========== Data ===================

; Here are the messages to output. the 13 and 10 bytes are used to end each line of output.


FlagStatements: 

db 'Floppy drive(Off for installed)',0
db 'Math Coprocessor',0
db 'RAM block A',0
db 'RAM block B',0
db 'Video Mode bit 0',0
db 'Video Mode bit 1',0
db 'Video Mode bit 2',0
db 'Odd number of floppy drives(on for true)',0
db 'More than 1 floppy drives(on for true)',0
db 'DMA',0
db 'Odd number of RS-232 Cards(Off for true)',0
db 'More than 1 RS-232 Cards',0
db 'Game Port',0
db 'Internal Modem Installed',0
db 'Odd Number of Printers attached',0
db 'More than 1 printer attached',0
 
;====================================

installed db 'flag on', 13, 10, '$'
NotInstalled db 'flag off', 13, 10, '$'

; '$' terminates the string for int 21h when ah=09h and dx=offset of the message    	