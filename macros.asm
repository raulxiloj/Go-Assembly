;--------------------------------------------------------------
;-----------------------macros generales-----------------------
;--------------------------------------------------------------

print macro cadena
    mov ah, 09h
    mov dx, offset cadena
    int 21h
endm

getChar macro
    mov ah, 01h
    int 21h
endm

;Macro para obtener texto del usuario
;param array = variable en donde se almacerana el texto 
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

;Macro para limpiar un array 
;param buffer = array de bytes
;param numBytes = numero de bytes a limpiar
;para caracter = caracter con el que se va a limpiar 
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
LOCAL while,printBlack,printWhite,printSpace,printDash,finwhile,printLine   
    mov si, 0       ;xor si,si
    mov cx, 0       ;counter for dashes
    mov bx, 0       ;counter for line-walls

    while:
        call printRowNum
        cmp table[si],48    
        je printBlack       
        cmp table[si],49     
        je printWhite          
        jmp printSpace      
    printBlack:
        print black         
        cmp cx, 7h          
        jne printDash       
        inc si              
        cmp bx, 7h          
        jne printLine       
        jmp finwhile        
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

;macro para obtener la ruta dada por un usuario
;similar al de getTexto, la unica diferencia es el fin de cadena
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
LOCAL movement,specialCommand,pass1,pass2,pass3,saveShow,save2,save3,exit1,exit2,exit3,show2,show3,finishPass,finishSave,finishShow,finishExit,fin
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
        ;CHANGE TURN
        changeTurn
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
        cleanBuffer table,SIZEOF table,24h
        jmp menuPrincipal
    finishShow:
        ;create html
        createActualReport
        jmp fin
    movement: 
        checkMove inst
        updateTable 
        hasLiberty
        countCX
    fin:
        print newLine
endm

;macro para verificar si el movimiento del jugador
;esta en los rangos establecidos y si la posicion esta libre
checkMove macro inst
    checkLetter inst[0]
    checkNum inst[1]
    getCoorX inst[0]
    getCoorY inst[1] 
    isEmpty 
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
    cmp char, 30h
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

;macro para verificar si una posicion esta vacia 
isEmpty macro
    mov bx,0h
    getBx
    getSI
    add bx, si
    cmp table[bx],24h
    jne errorPosition
endm

;macro para agregar movimiento en el tablero
updateTable macro 
LOCAL player1,player2,fin
    mov bx,0h
    getBx
    getSI
    add bx, si
    cmp player[0], 48
    je player1
    jmp player2
    player1:
        mov table[bx], 48
        jmp fin
    player2:
        mov table[bx], 49
    fin:
        changeTurn
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

;macro para verificar si la piedra a colocar tiene libertades
hasLiberty macro
LOCAL fin
    mov cx, 0ah 
    isCorner
    cmp cx, 0ah
    jne fin
    isSide
    cmp cx, 0ah
    jne fin
    fin:
endm

;macro para verificar si una posicion es una esquina
isCorner macro
LOCAL topLeft, topRight, bottomLeft, bottomRight, fin, countLOne, countLTwo,countROne,countRTwo,countBLone,countBLtwo,countBRone,countBRtwo
    mov bx,0h
    getBx
    getSI
    add bx, si
    cmp bx, 0h
    je topLeft
    cmp bx, 7h
    je topRight
    cmp bx, 38h
    je bottomLeft 
    cmp bx, 3Fh
    je bottomRight
    jmp fin

    topLeft:
        mov cx,0
        cmp table[1h],24h
        je countLOne
        cmp table[8h],24h
        je countLTwo
        jmp fin
        countLOne:
            call addOneCX
            cmp table[8h],24h
            je countLTwo
            jmp fin
        countLTwo:
            call addOneCX
            jmp fin
    topRight:
        mov cx,0
        cmp table[6h],24h
        je countROne
        cmp table[0Fh],24h
        je countRTwo
        jmp fin
        countROne:
            call addOneCX
            cmp table[0Fh],24h
            je countRTwo
            jmp fin
        countRTwo:
            call addOneCX
            jmp fin
    bottomLeft:
        mov cx,0
        cmp table[30h],24h
        je countROne
        cmp table[39h],24h
        je countRTwo
        jmp fin
        countBLone:
            call addOneCX
            cmp table[39h],24h
            je countLTwo
            jmp fin
        countBLtwo:
            call addOneCX
            jmp fin
    bottomRight:
        mov cx,0
        cmp table[37h],24h
        je countROne
        cmp table[3Eh],24h
        je countRTwo
        jmp fin
        countBRone:
            call addOneCX
            cmp table[3Eh],24h
            je countRTwo
            jmp fin
        countBRtwo:
            call addOneCX
            jmp fin
    fin:
endm

isSide macro 
LOCAL checkSide,fin,l1,l2,l3
    mov bx,0h
    getBx
    getSI
    add bx,si
    ;leftSide
    cmp bx,8h
    je checkSide
    cmp bx,10h
    je checkSide
    cmp bx,18h
    je checkSide
    cmp bx,20h
    je checkSide
    cmp bx,28h
    je checkSide
    cmp bx,30h
    je checkSide
    ;right side
    cmp bx,0Fh
    je checkSide
    cmp bx,17h
    je checkSide
    cmp bx,1Fh
    je checkSide
    cmp bx,27h
    je checkSide
    cmp bx,2Fh
    je checkSide
    cmp bx,37h
    je checkSide
    jmp fin

    checkSide:
        mov cx,0
        cmp table[bx+1],24h
        je l1
        cmp table[bx-8],24h
        je l2
        cmp table[bx+8],24h
        je l3
        jmp fin
        l1:
            call addOneCX
            cmp table[bx-8],24h
            je l2
            cmp table[bx+8],24h
            je l3
        l2: 
            call addOneCX
            cmp table[bx+8],24h
            je l3
            jmp fin
        l3: 
            call addOneCX
            jmp fin 
    fin:
endm

countCX macro
LOCAL cero,uno,dos,tres,cuatro,fin
    cmp cx, 0h
    je cero
    cmp cx, 1h
    je uno
    cmp cx, 2h
    je dos
    cmp cx, 3h
    je tres
    cero: 
        print temp0
        jmp fin
    uno:
        print temp1
        jmp fin
    dos:
        print temp2
        jmp fin
    tres:
        print temp3
        jmp fin
    cuatro:
        print temp4
    fin:
endm

;isCaptured

;macro para verificar si el movimiento seria suicido
suicide macro

endm

;Check if one token is captured
;captureOne macro
    ;isCorner 
    ;isSide
    ;isInside
;endm

;ko


changeTurn macro
LOCAL player1,player2,fin
    cmp player[0],48
    je player1
    jmp player2
    player1:
        mov player, 49
        jmp fin
    player2: 
        mov player, 48
        jmp fin
    fin:
endm

;macro para obtener la fecha
getTime macro
    lea bx, time
    call get_time
endm