createActualReport macro 
    createFile report, handler
    writeFile handler, doctype, SIZEOF doctype
    seekEnd handler
    writeFile handler, htmlInit, SIZEOF htmlInit
    seekEnd handler
    writeFile handler, headInit, SIZEOF headInit
    seekEnd handler
    writeFile handler, titleTag, SIZEOF titleTag
    seekEnd handler
    ;CSS
    writeFile handler,  links, SIZEOF links
    seekEnd handler
    writeFile handler, headEnd, SIZEOF headEnd
    seekEnd handler
    writeFile handler, bodyInit, SIZEOF bodyInit
    seekEnd handler
    ;h1 title
    writeFile handler, h1Title, SIZEOF h1Title
    seekEnd handler
    ;Tablero (divs)
    writeFile handler, divTable, SIZEOF divTable
    seekEnd handler
    ;PRINT ROWS
    printRows
    ;div letters
    writeFile handler, divLets, SIZEOF divLets
    seekEnd handler
    ;--------------
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;Time 
    writeFile handler, h1Time, SIZEOF h1Time
    seekEnd handler
    writeFile handler, date, SIZEOF date
    writeFile handler, time, SIZEOF time
    seekEnd handler
    writeFile handler, h1Time2, SIZEOF h1Time2
    seekEnd handler
    ;End
    writeFile handler, bodyEnd, SIZEOF bodyEnd
    seekEnd handler
    writeFile handler, htmlEnd, SIZEOF htmlEnd
    closeFile handler 
endm

printRows macro
LOCAL while, black, white, L2, plus,while2
    xor cx, cx
    xor si, si
    mov cx, 8h
    
    mov si, 0
    mov bl,48
    mov al,48
    while: 
        mov bl,48
        xor dx, dx
        mov dx, 8h
        pusha
        writeFile handler, divrow, SIZEOF divrow
        seekEnd handler
        popa
        add al, 1
        pusha 
        mov divNum[15],al
        writeFile handler, divNum, SIZEOF divNum
        seekEnd handler
        popa

        
        while2:
            cmp table[si],48
            je black
            cmp table[si],49
            je white
            jmp L2
            black:
                add bl,1
                mov divX[13],bl
                mov divX[14],66
                pusha 
                writeFile handler,divX, SIZEOF divX
                seekEnd handler
                popa
                jmp plus
            white:
                add bl,1
                mov divX[13],bl
                mov divX[14],87
                pusha 
                writeFile handler,divX, SIZEOF divX
                seekEnd handler
                popa
                jmp plus
            L2:
                add bl,1
                mov divX[13],88
                mov divX[14],88
                pusha 
                writeFile handler,divX, SIZEOF divX
                seekEnd handler
                popa
            plus:
                inc si
                dec dx
        cmp dx,0h
        jne while2
    pusha 
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    popa
    dec cx
    cmp cx, 0h
    jne while
endm

;Reporte final
createFinalReport macro 
    createFile reportF, handler
    writeFile handler, doctype, SIZEOF doctype
    seekEnd handler
    writeFile handler, htmlInit, SIZEOF htmlInit
    seekEnd handler
    writeFile handler, headInit, SIZEOF headInit
    seekEnd handler
    writeFile handler, titleTag, SIZEOF titleTag
    seekEnd handler
    ;CSS
    writeFile handler,  links, SIZEOF links
    seekEnd handler
    writeFile handler, headEnd, SIZEOF headEnd
    seekEnd handler
    writeFile handler, bodyInit, SIZEOF bodyInit
    seekEnd handler
    ;h1 title
    writeFile handler, h1Title2, SIZEOF h1Title
    seekEnd handler
    ;Tablero (divs)
    writeFile handler, divTable, SIZEOF divTable
    seekEnd handler
    ;PRINT ROWS
    printRows2
    ;div letters
    writeFile handler, divLets, SIZEOF divLets
    seekEnd handler
    ;--------------
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;Time 
    writeFile handler, h1Time, SIZEOF h1Time
    seekEnd handler
    writeFile handler, date, SIZEOF date
    writeFile handler, time, SIZEOF time
    seekEnd handler
    writeFile handler, h1Time2, SIZEOF h1Time2
    seekEnd handler
    ;End
    writeFile handler, bodyEnd, SIZEOF bodyEnd
    seekEnd handler
    writeFile handler, htmlEnd, SIZEOF htmlEnd
    closeFile handler 
endm

printRows2 macro
LOCAL while, black, white, L2, plus,while2
    xor cx, cx
    xor si, si
    mov cx, 8h
    
    mov si, 0
    mov bl,48
     mov al,48
    while: 
        mov bl,48
        xor dx, dx
        mov dx, 8h
        pusha
        writeFile handler, divrow, SIZEOF divrow
        seekEnd handler
        popa
        add al, 1
        pusha 
        mov divNum[15],al
        writeFile handler, divNum, SIZEOF divNum
        seekEnd handler
        popa
        while2:
            cmp table[si],48
            je black
            cmp table[si],49
            je white
            cmp table[si],50
            je circle
            cmp table[si],51
            je square
            jmp L2
            black:
                add bl,1
                mov divX[13],bl
                mov divX[14],66
                pusha 
                writeFile handler,divX, SIZEOF divX
                seekEnd handler
                popa
                jmp plus
            white:
                add bl,1
                mov divX[13],bl
                mov divX[14],87
                pusha 
                writeFile handler,divX, SIZEOF divX
                seekEnd handler
                popa
                jmp plus
            circle:
                add bl,1
                mov divSCT[10],99
                mov divSCT[11],105
                mov divSCT[12],114
                mov divSCT[13],bl
                pusha 
                writeFile handler,divSCT, SIZEOF divSCT
                seekEnd handler
                popa
                jmp plus
            square: 
                add bl,1
                mov divSCT[10],115
                mov divSCT[11],113
                mov divSCT[12],114
                mov divSCT[13],bl
                pusha 
                writeFile handler,divSCT, SIZEOF divSCT
                seekEnd handler
                popa
                jmp plus
            L2:
                add bl,1
                mov divSCT[10],116
                mov divSCT[11],114
                mov divSCT[12],105
                mov divSCT[13],bl
                pusha 
                writeFile handler,divSCT, SIZEOF divSCT
                seekEnd handler
                popa
                jmp plus
            plus:
                inc si
                dec dx
        cmp dx,0h
        jne while2
    pusha 
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    popa
    dec cx
    cmp cx, 0h
    jne while
endm