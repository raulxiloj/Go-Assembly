print macro cadena
    mov ah, 09h
    mov dx, offset cadena
    int 21h
endm

getChar macro
    mov ah, 01h
    int 21h
endm

;Macro que recorre un arreglo y en base a su contenido muestra el tablero
;table = arreglo, los demas parametros son solo 'strings'
;0 = Black | 1 = White | '$' = space
showTable macro table
LOCAL while    
    mov si, 0       ;xor si,si
    mov cx, 0       ;counter for dashes
    mov bx, 0       ;counter for line-walls

    while:
        call printRowNum
        cmp table[si],0     ;table[si] == 0
        je printBlack       ;yes -> printBlack
        cmp table[si],1     ;table[si] == 1
        je printWhite       ;yes -> printWhite   
        jmp printSpace      ;else -> printSpace
    printBlack:
        print black         
        cmp cx, 7h          ;cx == 8
        jne printDash       ;no -> printDash 
        inc si              ;yes: si++
        cmp bx, 7h          ;bx == 8 
        jne printLine       ;no -> printLine
        jmp finwhile        ;yes -> fin
    printWhite:
        print white
        cmp cx, 7h 
        jne printDash
        inc si
        cmp bl, 7h
        jne printLine
        jmp finwhile
    printSpace:
        print space         
        cmp cx, 7h 
        jne printDash
        inc si
        cmp bx, 7h
        jne printLine
        jmp finwhile
    printDash:
        print dash
        inc si 
        inc cx 
        jmp while
    printLine: 
        print newLine
        print wall
        mov cx,0
        inc bx
        jmp while
    finwhile:
        print newLine
        print columns
        
endm

getTexto macro inst
    mov si,0    ;xor si,si

    getCadena:
        getChar
        cmp al,0dh
        je finCadena
        mov inst[si],al
        inc si
        jmp getCadena
    finCadena:
    mov al,24h
    mov inst[si],al

endm

analizeInst macro inst
    mov si, 0
    call getLength 
    cmp si,2
    ;---movement---
    je movement
    cmp si,4
    je specialCommand
    jmp invalidCommand
    specialCommand:     ;mini analizador
        int 3
        mov si, 0
        cmp inst[si],80 ;Pass
        je pass1
        cmp inst[si],83 ;Save
        je saveShow
        cmp inst[si],69 ;Exit
        je exit1
        jmp invalidCommand
    pass1: ;pAss
        inc si
        cmp inst[si],65
        je pass2
        jmp invalidCommand
    pass2: ;paSs
        inc si 
        cmp inst[si],83
        je pass3
        jmp invalidCommand
    pass3: ;pasS
        inc si 
        cmp inst[si],83
        je finishPass 
        jmp invalidCommand
    saveShow: ;Check if is save or show
        inc si 
        cmp inst[si],65
        je save2
        cmp inst[si],72
        je show2
        jmp invalidCommand
    save2: ;saVe
        inc si
        cmp inst[si],86
        je save3
        jmp invalidCommand
    save3: ;savE
        inc si
        cmp inst[si],69
        je finishSave
        jmp invalidCommand
    exit1: ;eXit
        inc si
        cmp inst[si],88
        je exit2
        jmp invalidCommand
    exit2: ;exIt
        inc si
        cmp inst[si],73
        je exit3
        jmp invalidCommand
    exit3: ;exiT
        inc si
        cmp inst[si],84
        je finishExit
        jmp invalidCommand
    show2: ;shOw
        inc si
        cmp inst[si],79
        je show3
        jmp invalidCommand
    show3: ;shoW
        inc si
        cmp inst[si],87
        je finishShow
        jmp invalidCommand
    finishPass:
        print inst
        ;CHANGE TURN
        jmp fin
    finishSave:
        print inst
        ;SAVE BOARD
        jmp fin
    finishExit:
        print inst
        ;back to the
        jmp fin
    finishShow:
        print inst
        ;Create html
        jmp fin
    invalidCommand:
        print error2
        jmp fin
    movement: 
        print load
    fin:
        print newLine
    
endm
