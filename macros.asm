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
        call printLetters
        
endm

updateTable macro arreglo
endm

