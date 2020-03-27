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
        cmp contPass, 2h
        je gameOver
        mov contPass, 2h
        changeTurn
        jmp fin
    finishSave:
        ;SAVE BOARD
        print inputFile
        getRuta file
        createFile file,handler
        writeFile handler,table,SIZEOF table
        print saved
        closeFile handler
        cmp player[0],48
        je player1
        jmp player2
    finishExit:
        cleanBuffer table,SIZEOF table,24h
        jmp menuPrincipal
    finishShow:
        ;create html
        getDate
        getTime
        createActualReport
        print created
        cmp player[0],48
        je player1
        jmp player2
    movement: 
        checkMove inst
        captureOne
        updateTable 
    fin:
        print newLine
endm

;macro para verificar si el movimiento del jugador
;esta en los rangos establecidos y si la posicion esta libre
checkMove macro inst
    checkLetter inst[0]
    checkNum inst[1]
    getCoorY inst[0]
    getCoorX inst[1] 
    checkSuicide
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
LOCAL case0,case1,case2,case3,case4,case5,case6,case7,fin
    cmp char,49
    je case7
    cmp char,50
    je case6
    cmp char,51
    je case5
    cmp char,52
    je case4
    cmp char,53
    je case3
    cmp char,54
    je case2
    cmp char,55
    je case1
    cmp char,56
    je case0
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

getCoorY macro char
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
        mov contPass, 1h
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
    isInside
    fin:
endm

;macro para verificar si una posicion es una esquina y contas sus libertades
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

;macro para verificar si una posicion es un lado y contar sus libertades
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
    fin:
endm

;macro para contar las libertades de una posicion del centro
isInside macro
LOCAL c1,c2,c3,c4,fin    
    mov cx,0
    mov bx,0
    getBx
    getSI
    add bx,si
    cmp table[bx-1],24h
    je c1
    cmp table[bx+1],24h
    je c2
    cmp table[bx-8],24h
    je c3
    cmp table[bx+8],24h
    je c4
    jmp fin
    c1:
        call addOneCX
        cmp table[bx+1],24h
        je c2
        cmp table[bx-8],24h
        je c3
        cmp table[bx+8],24h
        je c4
        jmp fin
    c2: 
        call addOneCX
        cmp table[bx-8],24h
        je c3
        cmp table[bx+8],24h
        je c4
        jmp fin
    c3:
        call addOneCX
        cmp table[bx+8],24h
        je c4
        jmp fin
    c4:
        call addOneCX
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
    cmp cx, 4h
    je cuatro
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

;macro para verificar si el movimiento seria suicido
checkSuicide macro
    hasLiberty
    ;countCX
    cmp cx, 0
    je suicide 
endm

;Check if one token is captured
captureOne macro
    LOCAL leftSide,colFor,colFor2,colBack,colBack2,rowFor,rowBack,topLeft1,bottomLeft1,rightSide,topRight1,bottomRight1,rowFor2,rowBack2,topSide,topLeft2,topRight2,topAll,bottomSide,bottomLeft2,bottomRight2,bottomAll,center,row2,row7,col2,col7,else,fin, col21, col22, col23,finCol,col71,col72,col73,finCol7
    cmp coor[1],48       ;Colum0 (Left side)
    je leftSide
    cmp coor[1],55       ;Column7 (Right side)
    je rightSide
    cmp coor[0],48       ;row0 (Top side)
    je topSide
    cmp coor[0],55       ;row7 (Bottom side)
    je bottomSide
    jmp center

    ;----------Checking left side-------------
    leftSide:            
        cmp coor[0],53  ;if row <= 5
        jbe colFor      ;colFor
        jmp colBack     ;else colBack     
    colFor:;LEFT
        mov ax,49
        push ax
        call colForward
        cmp coor[0],48   ;if row == 0 
        je rowFor        ;rowFor
        cmp coor[0],49   ;if row == 1
        je topLeft1
        jmp colBack      ;else colBack (row >= 2)
    colBack:
        mov ax,49
        call colBackward
        cmp coor[0],54   ;if row == 6
        je bottomLeft1       
        jmp rowFor2       ;else row = 7
    rowFor:
        call rowForward
        jmp fin
    rowFor2:
        call rowForward2
        jmp fin
    topLeft1: 
        call cornerTopLeft1
        jmp colBack
    bottomLeft1:
        call cornerBottomLeft1
        jmp fin
    ;----------Checking right side-------------
    rightSide:
        cmp coor[0],53  ;if row <= 5
        jbe colFor2     ;colFor2
        jmp colBack2
    colFor2:;RIGHT
        mov ax,48
        push ax
        call colForward
        cmp coor[0],48   ;if row == 0 
        je rowBack       ;rowBack
        cmp coor[0],49   ;if row == 1
        je topRight1
        jmp colBack2 
    rowBack:
        call rowBackward
        jmp fin
    rowBack2:
        call rowBackward2
        jmp fin
    colBack2:
        mov ax,48
        call colBackward
        cmp coor[0],54  ;if row == 6
        je bottomRight1
        jmp rowBack2    ;else row = 7
    topRight1:
        call cornerTopRight1
        jmp fin
    bottomRight1:
        call cornerBottomRight1
        jmp fin
    ;-----------Checking top side------------
    topSide:
        cmp coor[1],49
        je topLeft2
        cmp coor[1],54
        je topRight2
        jmp topAll
        topLeft2:
            call rowForward
            call cornerTopLeft2 
            jmp fin
        topRight2:
            call rowBackward
            call cornerTopRight2
            jmp fin
        topAll:
            call rowForward
            call rowBackward
            jmp fin
    ;----------Checking bottom side----------
    bottomSide:
        cmp coor[1],49
        je bottomLeft2 
        cmp coor[1],54
        je bottomRight2
        jmp bottomAll
        bottomLeft2:
            call rowForward2
            call cornerBottomLeft2
            jmp fin
        bottomRight2:
            call rowBackward2
            call cornerBottomRight2
            jmp fin
        bottomAll:
            call rowForward2
            call rowBackward2
            jmp fin
    ;---------------Check center-------------
    center:
        cmp coor[0],49  ;if row == 2
        je row2
        cmp coor[0],54  ;if row == 7
        je row7
        cmp coor[1],49  ;if col == 2
        je col2 
        cmp coor[1],54  ;if col == 7
        je col7
        jmp else
        row2:
            call checkRow2
            call checkRow2A
            jmp fin
        row7:
            call checkRow7
            call checkRow7A
            jmp fin
        col2:
            cmp coor[0],48  ;row == 1 
            je col21
            cmp coor[0],49  ;row == 2
            je col21
            cmp coor[0],54 
            je col22 
            cmp coor[0],55
            je col22
            jmp col23
            col21:
                call checkDown
                jmp finCol
            col22:
                call checkUp
                jmp finCol
            col23:
                call checkUp
                call checkDown
            finCol:
                call checkCol2
                call checkRight
                jmp fin
        col7:
            cmp coor[0],48  ;row == 1 
            je col71
            cmp coor[0],49  ;row == 2
            je col71
            cmp coor[0],54 
            je col72 
            cmp coor[0],55
            je col72
            jmp col73
            col71:
                call checkDown
                jmp finCol7
            col72:
                call checkUp
                jmp finCol
            col73:
                call checkUp
                call checkDown
            finCol7:
                call checkCol7
                call checkLeft
                jmp fin
        else:
            call checkUp
            call checkDown
            call checkLeft
            call checkRight
    fin:
endm

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
    fin:
endm

countTokens macro
LOCAL while1,while2,black,white,fin,fin2
    xor si, si  ;Contador general
    mov al, 00h ;contador para los tokes negros

    while1:
        cmp table[si],48    ;black
        je black
        cmp table[si],50    ;black
        je black
        jmp fin
        black:
            inc al
            jmp fin
        fin: 
        inc si
    cmp si, 40h
    jne while1

    call convert

    mov pointsB[15],ah
    mov pointsB[16],al

    xor si, si 
    mov al, 00h

    while2:
        cmp table[si],49    ;white
        je white
        cmp table[si],51    ;white
        je white
        jmp fin2
        white:
            inc al
        fin2: 
        inc si
    cmp si, 40h
    jne while2

    call convert
    mov pointsW[15],ah
    mov pointsW[16],al

    print pointsB
    print pointsW 
endm