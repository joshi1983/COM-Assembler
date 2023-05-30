;  program writes data directly to display memory


mov ax, B800h
mov es,ax  ; video memory starts at B800:0000h in display mode 03h

mov ax,word[CharacterAtt]
mov cx,2000
mov di,0
start:
   stosw    
   loop start

RET ; exit and return to dos

CharacterAtt db 'H',F0h