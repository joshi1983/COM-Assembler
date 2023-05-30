;  program fills the screen with A's


mov ah,02h
mov dh,0 ; row
mov dl,0 ; column
mov bh,0 ; video page 0
int 10h ; go to it

mov ah,09h ; display char and attribute action
mov cx,2000 ; 25*80
mov al,'A' ; letter to repeat
mov bl,10001100b ; attribute (colours) for each character
mov bh,0 ; video page 0
int 10h ; go do it


RET ; exit and return to dos