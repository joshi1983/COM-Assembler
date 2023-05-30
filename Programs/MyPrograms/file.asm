; .386
; .Radix	10h
; S16	Segment Use16 Page
ORG	0100h
; ASSUME	Cs:S16, Ds:S16
_Entry16:


	Mov	Ax,		3C00h			;Create code
	Mov	Cx,		0030h			;Archived file attribute
	mov	Dx,		offset _StrName		;Name
	Int	21h					;Commit
	  Jc	_b0_Open				;Cannot create; exists maybe
  _r0:							;Successful open always ends up here
  ;Write data to file					;
	Mov	Bx,		Ax			;Load handle into Bx
	Mov	Ax,		4000h			;Write code
	Mov	Cx,		0010h			;Sixteen bytes
	mov	Dx,		offset _DataFile	;Buffer
	Int	21h					;Output
	  Jc	_Fail

	Mov	Ax,		3Dh			;Close (Bx remains set)
	Int	21h					;Exit
_Exit16:						;Exit
	Int	20h					;Exit

_b0_Open:						;Create failed, try to open
	Mov	Ax,		3D10h			;Open code (r/w mode)
	Int	21h					;Attempt to open
	  Jc	_Fail					;
	Jmp	_r0					;Return from branch 0

_Fail:							;Failed
	mov	Dx,		offset _MsgFail		;Failed
	Mov	Ax,		0900h			;Output to console
	Int	21h					;Print
	Jmp	_Exit16

_MsgFail:	Db 'File open failed$'
_StrName:	Db 'file0.txt',0
_DataFile:	Db '0123456789ABCDEF'

; S16	Ends
; End	_Entry16