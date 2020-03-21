print macro cadena
    mov ah, 09h
    mov dx, offset cadena
    int 21h
endm

getChar macro
    mov ah, 01h
    int 21h
endm

getTexto macro array
LOCAL getCadena, finCadena
    mov si,0    ;xor si,si

    getCadena:
        getChar
        cmp al,0dh
        je finCadena
        mov array[si],al
        inc si
        jmp getCadena
    finCadena:
    mov al,24h
    mov array[si],al
    
endm

cleanBuffer macro buffer,numBytes,caracter
LOCAL repeat 
    mov si,0
    mov cx,0
    mov cx,numBytes
    repeat:
    mov buffer[si],caracter
    inc si
    loop repeat
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
        cmp table[si],48    ;table[si] == 0
        je printBlack       ;yes -> printBlack
        cmp table[si],49     ;table[si] == 1
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

getRuta macro array
LOCAL getCadena, finCadena
    mov si,0    ;xor si,si

    getCadena:
        getChar
        cmp al,0dh
        je finCadena
        mov array[si],al
        inc si
        jmp getCadena
    finCadena:
    mov al,00h
    mov array[si],al

endm

;Analizador para las comandos especiales
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
        ;SAVE BOARD
        getRuta file
        createFile file,handler
        writeFile handler,table,SIZEOF table
        print saved
        closeFile handler
        jmp fin
    finishExit:
        print inst
        ;back to the
        jmp fin
    finishShow:
        ;html
        createActualReport
        jmp fin
    invalidCommand:
        print error2
        jmp fin
    movement: 
        checkMove inst
    fin:
        print newLine
    
endm

checkMove macro inst
    checkLetter inst[0]
    checkNum inst[1]
    getCoorX inst[0]
    getCoorY inst[1]   
    updateTable
endm

checkLetter macro char 
LOCAL continue    
    cmp char, 40h
    jg continue
    jmp errorLetter
    continue:
    cmp char, 48h
    jg errorLetter
endm

checkNum macro char
LOCAL continue    
    cmp char, 2Fh
    jg continue
    jmp errorNumber
    continue:
    cmp char, 38h
    jg errorNumber
endm

getCoorX macro char
LOCAL caseA,caseB,caseC,caseD,caseE,caseF,caseG,caseH,fin
    cmp char,'A'
    je caseA
    cmp char,'B'
    je caseB
    cmp char,'C'
    je caseC
    cmp char,'D'
    je caseD
    cmp char,'E'
    je caseE
    cmp char,'F'
    je caseF
    cmp char,'G'
    je caseG
    cmp char,'H'
    je caseH
    caseA: 
        mov coor[1],48
        jmp fin
    caseB: 
        mov coor[1],49
        jmp fin
    caseC: 
        mov coor[1],50
        jmp fin
    caseD: 
        mov coor[1],51
        jmp fin
    caseE: 
        mov coor[1],52
        jmp fin
    caseF: 
        mov coor[1],53
        jmp fin
    caseG: 
        mov coor[1],54
        jmp fin
    caseH: 
        mov coor[1],55
        jmp fin
    fin:
        
endm

getCoorY macro char
LOCAL case0,case1,case2,case3,case4,case5,case6,case7,fin
    cmp char,49
    je case0
    cmp char,50
    je case1
    cmp char,51
    je case2
    cmp char,52
    je case3
    cmp char,53
    je case4
    cmp char,54
    je case5
    cmp char,55
    je case6
    cmp char,56
    je case7
    case0: 
        mov coor[0],48
        jmp fin
    case1: 
        mov coor[0],49
        jmp fin
    case2: 
        mov coor[0],50
        jmp fin
    case3: 
        mov coor[0],51
        jmp fin
    case4: 
        mov coor[0],52
        jmp fin
    case5: 
        mov coor[0],53
        jmp fin
    case6: 
        mov coor[0],54
        jmp fin
    case7: 
        mov coor[0],55
        jmp fin
    fin:
        
endm

updateTable macro
    int 3
    mov bx,0h
    getBx
    getSI
    add bx, si
    mov table[bx], 49
endm

getBx macro
LOCAL case0,case1,case2,case3,case4,case5,case6,case7,fin
    cmp coor[0h],48
    je case0
    cmp coor[0h],49
    je case1
    cmp coor[0h],50
    je case2
    cmp coor[0h],51
    je case3
    cmp coor[0h],52
    je case4
    cmp coor[0h],53
    je case5
    cmp coor[0h],54
    je case6
    cmp coor[0h],55
    je case7
    case0: 
        add bx, 8*0
        jmp fin
    case1: 
        add bx, 8*1
        jmp fin
    case2: 
        add bx, 8*2
        jmp fin
    case3: 
        add bx, 8*3
        jmp fin
    case4: 
        add bx, 8*4
        jmp fin
    case5: 
        add bx, 8*5
        jmp fin
    case6: 
        add bx, 8*6
        jmp fin
    case7: 
        add bx, 8*7
    fin:
endm

getSI macro
LOCAL case0,case1,case2,case3,case4,case5,case6,case7,fin
    cmp coor[1h],48
    je case0
    cmp coor[1h],49
    je case1
    cmp coor[1h],50
    je case2
    cmp coor[1h],51
    je case3
    cmp coor[1h],52
    je case4
    cmp coor[1h],53
    je case5
    cmp coor[1h],54
    je case6
    cmp coor[1h],55
    je case7
    case0: 
        mov si,0h
        jmp fin
    case1: 
        mov si,1h
        jmp fin
    case2: 
        mov si,2h
        jmp fin
    case3: 
        mov si,3h
        jmp fin
    case4: 
        mov si,4h
        jmp fin
    case5: 
        mov si,5h
        jmp fin
    case6: 
        mov si,6h
        jmp fin
    case7: 
        mov si,7h
    fin:
endm
