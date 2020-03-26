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
    ;row1
    writeFile handler, divrow, SIZEOF divrow
    seekEnd handler
    ;cols of row1
    printRow1
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row2
    writeFile handler, divrow, SIZEOF divrow
    seekEnd handler
    ;cols of row2
    printRow2
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row3
    writeFile handler, divrow, SIZEOF divrow
    seekEnd handler
    ;cols of row3
    printRow3
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row4
    writeFile handler, divrow, SIZEOF divrow
    seekEnd handler
    ;cols of row4
    printRow4
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row5
    writeFile handler, divrow, SIZEOF divrow
    seekEnd handler
    ;cols of row5
    printRow5
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row6
    writeFile handler, divrow, SIZEOF divrow
    seekEnd handler
    ;cols of row6
    printRow6
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row7
    writeFile handler, divrow, SIZEOF divrow
    seekEnd handler
    ;cols of row7
    printRow7
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row8
    writeFile handler, divrow, SIZEOF divrow
    seekEnd handler
    ;cols of row8
    printRow8
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
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

printRow1 macro
LOCAL mientras,black,white,L2,plus
    mov divNum[15],49
    writeFile handler,divNum, SIZEOF divX
    seekEnd handler
    xor cx,cx
    mov si,0h
    mov bl,48
    mientras:
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
        inc cx
        inc si
        cmp cx, 7h
        jbe mientras
endm

printRow2 macro
LOCAL mientras,black,white,L2,plus
    mov divNum[15],50
    writeFile handler,divNum, SIZEOF divX
    seekEnd handler
    xor cx,cx
    mov cx,8h
    mov si,8h
    mov bl,48
    mientras:
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
        inc cx
        inc si
        cmp cx, 0Fh
        jbe mientras
endm

printRow3 macro
LOCAL mientras,black,white,L2,plus
    mov divNum[15],51
    writeFile handler,divNum, SIZEOF divX
    seekEnd handler
    xor cx,cx
    mov cx,10h
    mov si,10h
    mov bl,48
    mientras:
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
        inc cx
        inc si
        cmp cx, 17h
        jbe mientras
endm

printRow4 macro
LOCAL mientras,black,white,L2,plus
    mov divNum[15],52
    writeFile handler,divNum, SIZEOF divX
    seekEnd handler
    xor cx,cx
    mov cx,18h
    mov si,18h
    mov bl,48
    mientras:
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
        inc cx
        inc si
        cmp cx, 1Fh
        jbe mientras
endm

printRow5 macro
LOCAL mientras,black,white,L2,plus
    mov divNum[15],53
    writeFile handler,divNum, SIZEOF divX
    seekEnd handler
    xor cx,cx
    mov cx,20h
    mov si,20h
    mov bl,48
    mientras:
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
        inc cx
        inc si
        cmp cx, 27h
        jbe mientras
endm

printRow6 macro
LOCAL mientras,black,white,L2,plus
    mov divNum[15],54
    writeFile handler,divNum, SIZEOF divX
    seekEnd handler
    xor cx,cx
    mov cx,28h
    mov si,28h
    mov bl,48
    mientras:
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
        inc cx
        inc si
        cmp cx, 2Fh
        jbe mientras
endm

printRow7 macro
LOCAL mientras,black,white,L2,plus
    mov divNum[15],55
    writeFile handler,divNum, SIZEOF divX
    seekEnd handler
    xor cx,cx
    mov cx,30h
    mov si,30h
    mov bl,48
    mientras:
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
        inc cx
        inc si
        cmp cx, 37h
        jbe mientras
endm

printRow8 macro
LOCAL mientras,black,white,L2,plus
    mov divNum[15],56
    writeFile handler,divNum, SIZEOF divX
    seekEnd handler
    xor cx,cx
    mov cx,38h
    mov si,38h
    mov bl,48
    mientras:
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
        inc cx
        inc si
        cmp cx, 3Fh
        jbe mientras
endm


