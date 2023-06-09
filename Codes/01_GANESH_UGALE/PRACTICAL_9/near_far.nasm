;************************************************************
global    far_proc      

extern    filehandle, char, buf, abuf_len

%include "maa.nasm"
;************************************************************
section .data
    nline        db    10,10
    nline_len:    equ    $-nline

    smsg        db    10,"No. of spaces are    : "
    smsg_len:    equ    $-smsg
   
    nmsg        db    10,"No. of lines are    : "
    nmsg_len:    equ    $-nmsg

    cmsg        db    10,"No. of character occurances are    : "
    cmsg_len:    equ    $-cmsg


;************************************************************
section .bss

    scount    resq    1
    ncount    resq    1
    ccount    resq    1

    dispbuff    resb    4

;************************************************************
section .text
;    global    _main
;_main:

far_proc:                  ;FAR Procedure
   
        mov    eax,0
        mov    ebx,0
        mov    ecx,0
        mov    esi,0  

        mov    bl,[char]
        mov    esi,buf
        mov    ecx,[abuf_len]

again:    mov    al,[esi]

case_s:    cmp    al,20h        ;space : 32 (20H)
        jne    case_n
        inc    dword[scount]
        jmp    next

case_n:    cmp    al,0Ah        ;newline : 10(0AH)
        jne    case_c
        inc    dword[ncount]
        jmp    next

case_c:    cmp    al,bl            ;character
        jne    next
        inc    dword[ccount]

next:        inc    esi
        dec    ecx            ;
        jnz    again            ;loop again

        display smsg,smsg_len
        mov    ebx,[scount]
        call    display16_proc
   
        display nmsg,nmsg_len
        mov    ebx,[ncount]
        call    display16_proc

        display cmsg,cmsg_len
        mov    ebx,[ccount]
        call     display16_proc

    fclose    [filehandle]
    ret


;************************************************************
display16_proc:
    mov edi,dispbuff    ;point esi to buffer
    mov ecx,4        ;load number of digits to display
dispup1:
    rol bx,4        ;rotate number left by four bits
    mov dl,bl        ;move lower byte in dl
    and dl,0fh        ;mask upper digit of byte in dl
    add dl,30h        ;add 30h to calculate ASCII code
    cmp dl,39h        ;compare with 39h
    jbe dispskip1        ;if less than 39h akip adding 07 more
    add dl,07h        ;else add 07

dispskip1:
    mov [edi],dl        ;store ASCII code in buffer
    inc edi            ;point to next byte
    loop dispup1        ;decrement the count of digits to display
                ;if not zero jump to repeat

    display dispbuff,4    ;
   
    ret
;************************************************************
