section .data

	hexinmsg db 10,10,'Please enter 4 digit hex number::'
	hexinmsg_len equ $-hexinmsg

	bcdopmsg db 10,10,'BCD Equivalent::'
	bcdopmsg_len equ $-bcdopmsg

section .bss
	numascii resb 06		;common buffer for choice, hex and bcd input
	ansbuff resb 02
	dnumbuff resb 08

%macro disp 2
	mov eax,04
	mov ebx,01
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

%macro accept 2
	mov eax,3
	mov ebx,0
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro

section .text
global _start
_start:
 
       call hex2bcd

	mov eax,1
	mov ebx,0
	int 80h

hex2bcd:
	disp hexinmsg,hexinmsg_len
	accept numascii,5
	call atoh
	mov ax,bx               ;ax=given hex number
	mov bx,10		;Base of Decimal No. system
        mov ecx,0
h2b1:	mov dx,0
	div bx                     ;bx=divisior edx=store remainder
	push edx		;push remainder
	inc ecx
	cmp ax,0
	jne h2b1

	mov edi,ansbuff

h2b2:	pop edx
	add dl,30h
	mov [edi],dl
	inc edi
	loop h2b2
	
	disp bcdopmsg,bcdopmsg_len
	disp ansbuff,5
	ret
;---------------------------------Logic End-------------------------
atoh:
	mov bx,0
	mov ecx,04
	mov esi,numascii
up1:
	rol bx,04
	mov al,[esi]
        sub al,30h 
	cmp al,09h
	jbe skip1
	sub al,07h
skip1:add bl,al
	inc esi
	loop up1
	ret 
	


     

