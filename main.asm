include macros.asm 
include files.asm
include reports.asm
.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header    db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,13,"FACULTAD DE INGENIERIA",10,13,"CIENCIAS Y SISTEMAS",10,13,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,13,"NOMBRE: RAUL XILOJ",10,13,"CARNET: 201612113",10,13,"SECCION: A",10,10,13,'$'
options   db "1) Iniciar juego",10,13,"2) Cargar juego",10,13,"3) Salir",10,13,"Ingrese una opcion: ",'$'
table     db 64 dup('$')
row       db "  ",'$' 
columns   db "  A   B   C   D   E   F   G   H",10,10,13,'$'
newLine   db 10,'$'
dash      db "---",'$' 
wall      db "  |   |   |   |   |   |   |   |",10,13,'$'
white     db "O",'$'
black     db "X",'$'
space     db " ",'$'
turn1     db "Turno negras: ",'$'
turn2     db "Turno blancas: ",'$'
inst      db 10 dup('$')
coor      db 2 dup('$'),'$'
player    db 48
time      db "00:00:00",'$'      
;---------------------File messages and variables---------------------
file      db 50 dup('$')
fileData  db 64 dup('$')
inputFile db 10,13,"Ingrese la ruta del archivo ",10,13,"(Ejemplo: c:\entrada.arq)",10,10,13,'$'
reading   db "Leyendo el archivo...",10,13,'$'
handler   dw ?
saved     db "Juego guardado con exito",10,13,'$'
;----------------------------HTML tags--------------------------------
report    db "c:\Actual.html",0
doctype   db "<!DOCTYPE html>",10
htmlInit  db "<html lang=en>",10
headInit  db "<head>",10
titleTag  db "      <title> Reporte actual </title>",10
links     db "      <link rel='stylesheet' href='main.css'>",10
css       db "      <link rel='stylesheet' href='row2.css'>",10,"      <link rel='stylesheet' href='row3.css'>",10,"      <link rel='stylesheet' href='row4.css'>",10
css2      db "      <link rel='stylesheet' href='row5.css'>",10,"      <link rel='stylesheet' href='row6.css'>",10 
css3      db "      <link rel='stylesheet' href='row7.css'>",10,"      <link rel='stylesheet' href='row8.css'>",10
headEnd   db "</head>",10
bodyInit  db "<body>",10
divTable  db "<div id=tablero>",10
divr1     db "<div id=row1>",10
divr2     db "<div id=row2>",10
divr3     db "<div id=row3>",10
divr4     db "<div id=row4>",10
divr5     db "<div id=row5>",10
divr6     db "<div id=row6>",10
divr7     db "<div id=row7>",10
divr8     db "<div id=row8>",10
divX      db "<div id=rowXXX>",10
divEnd    db "</div>",10
bodyEnd   db "</body>",10
htmlEnd   db "</html>"
;--------------------------Possibles errors:--------------------------
error     db 10,10,13,"Error: caracter invalido",10,10,13,'$'
error2    db 10,13,"Error: comando no reconocido",10,10,13,'$'
error3    db 10,10,13,"Error al abrir archivo",10,10,13,'$'
error4    db 10,10,13,"Error al cerrar archivo",10,10,13,'$'
error5    db 10,10,13,"Error al escribir en el archivo",10,10,13,'$'
error6    db 10,10,13,"Error al crear el archivo",10,10,13,'$'
error7    db 10,10,13,"Error al leer el archivo",10,10,13,'$'
error8    db 10,13,"Error: letra no valida",10,10,13,'$'
error9    db 10,13,"Error: numero no valido",10,10,13,'$'
error10   db 10,10,13,"Error: moviendo el puntero del fichero",10,10,13,'$'
error11   db 10,13,"Error: Posicion ya ocupada",10,10,13,'$'
error12   db 10,13,"Error: Movimiento prohibido, seria suicidio",10,10,13,'$'
prueba    db "Esto es una prueba gg",'$'
temp0     db "Tiene 0 libertades",10,13,'$'
temp1     db "Tiene 1 libertad",10,13,'$'
temp2     db "Tiene 2 libertades",10,13,'$'
temp3     db "Tiene 3 libertades",10,13,'$'
temp4     db "Tiene 4 libertades",10,13,'$'
;----------------------------------------------------------------------------------------------
;-----------------------------------------Code segment-----------------------------------------
;----------------------------------------------------------------------------------------------
.code
main proc
        mov ax, @data
        mov ds,ax
        print header
        getTime
        menuPrincipal:
                print options
                getChar
                cmp al, 31h
                je startGame
                cmp al, 32h
                je loadGame
                cmp al, 33h
                je finishGame
                jmp invalidChar
        startGame:
                mov player[0],48
                print newLine
                print newLine
                showTable table
                jmp turns
        turns:
                cmp player,48
                je player1 
                jmp player2
                player1: 
                        print turn1
                        getTexto inst
                        analizeInst inst
                        cleanBuffer inst, SIZEOF inst, 24h 
                        showTable table
                player2:
                        print turn2 
                        getTexto inst 
                        analizeInst inst
                        cleanBuffer inst, SIZEOF inst, 24h
                        showTable table
                jmp turns
        loadGame:
                print newLine
                print inputFile
                getRuta file
                openFile file,handler
                readFile handler,fileData,SIZEOF fileData
                cleanBuffer file,SIZEOF file,24h
                ;TODO:charge data to the table then clean
                closeFile handler
                print reading
                print fileData
                print newLine
                cleanBuffer fileData,SIZEOF fileData,24h
                jmp menuPrincipal
        invalidChar:
                print error
                jmp menuPrincipal
        errorOpening:
                print error3
                jmp menuPrincipal
        errorReading:
                print error7
                jmp menuPrincipal
        errorClosing:
                print error4
                jmp menuPrincipal
        errorCreating:
                print error6
                jmp menuPrincipal
        errorWriting:
                print error5
                jmp menuPrincipal
        errorLetter:
                print error8
                cmp player[0],48
                je player1
                jmp player2
        errorNumber:
                print error9
                cmp player[0],48
                je player1
                jmp player2
        errorAppending:
                print error10
                jmp menuPrincipal
        errorPosition:
                print error11
                cmp player[0],48
                je player1
                jmp player2
        invalidCommand:
                print error2
                cmp player[0],48
                je player1
                jmp player2
        suicide:
                print error12
                cmp player[0],48
                je player1
                jmp player2
        finishGame:
                mov ah, 4ch
                int 21h

main endp

;--------------------------------------------------------------
;--------------------------Procedures--------------------------
;--------------------------------------------------------------

printRowNum proc
        cmp cx, 0
        jne fin
        cmp bx, 0
        je print8
        cmp bx, 1
        je print7
        cmp bx, 2
        je print6
        cmp bx, 3
        je print5
        cmp bx, 4
        je print4
        cmp bx, 5
        je print3
        cmp bx, 6
        je print2
        cmp bx, 7
        je print1
        print1:
                mov row,49
                print row
                jmp fin
        print2:
                mov row,50
                print row
                jmp fin
        print3:
                mov row,51
                print row
                jmp fin
        print4:
                mov row,52
                print row
                jmp fin
        print5:
                mov row,53
                print row
                jmp fin
        print6:
                mov row,54
                print row
                jmp fin
        print7:
                mov row,55
                print row
                jmp fin
        print8:
                mov row,56
                print row
                jmp fin
        fin:
        
ret
printRowNum endp

getLength proc
mov si,0
        mientras:
        cmp inst[si],24h
        je finmientras
        inc si
        jmp mientras
        finmientras:
ret
getLength endp

; this procedure will get the current system time 
; input : BX=offset address of the string TIME
; output : BX=current time
get_time proc
        push ax
        push cx

        mov ah, 2ch    ;get the current system time
        int 21h

        mov al, ch
        call convert
        mov bx, ax
        
        mov al, cl
        call convert
        mov [bx+3], ax

        mov al, dh
        call convert
        mov [bx+6], ax

        pop cx
        pop ax
ret
get_time endp

 ; this procedure will convert the given binary code into ASCII code
 ; input : AL=binary code
; output : AX=ASCII code
convert proc
        push dx

        mov ah, 0
        mov dl, 10
        div dl
        or ax, 3030h

        pop dx
ret
convert endp

AddOneCX proc
        inc cx
ret
AddOneCX endp

;Procedures para verificar el lado izquierdo
colForward proc
        push bp ;metemos en el stack el valor del bp del proc que llamo a este proc
        mov bp, sp

        mov dx, [bp+4]
        cmp dx, 49
        je leftSide
        jmp rightSide

        leftSide:
                mov cl, table[bx+9]
                cmp cl, player[0]
                je f1
                jmp fin
        rightSide:
                mov cl, table[bx+7]
                cmp cl, player[0]
                je f1
                jmp fin
        f1: 
            mov cl,table[bx+16]
            cmp cl,player[0]
            je f2 
            jmp fin
        f2: 
            mov cl, table[bx+8]
            cmp cl,player[0]
            jne cap1
            jmp fin
        cap1: 
            mov table[bx+8],24h
        fin:
        mov sp, bp ;Desocupamos del stack las variables locales almacenadas en el stack, en este caso no se usaron varialbes locales entonces no hace nada
        pop bp ;Ponemos bp de regreso al valor del bp del proc llamo este proc
ret
colForward endp

colBackward proc
        push bp ;metemos en el stack el valor del bp del proc que llamo a este proc
        mov bp, sp
        mov dx, [bp+4]
        cmp dx, 49
        je leftSide
        jmp rightSide

        leftSide:
                mov cl, table[bx-7]
                cmp cl, player[0]
                je b1
                jmp fin
        rightSide:
                mov cl, table[bx-9]
                cmp cl, player[0]
                je b1
                jmp fin

        b1:
            mov cl, table[bx-16]
            cmp cl, player[0]
            je b2
            jmp fin
        b2:
            mov cl, table[bx-8]
            cmp cl, player[0]
            jne cap2
        cap2:
            mov table[bx-8],24h
        fin:
        mov sp, bp ;Desocupamos del stack las variables locales almacenadas en el stack, en este caso no se usaron varialbes locales entonces no hace nada
        pop bp ;Ponemos bp de regreso al valor del bp del proc llamo este proc
ret
colBackward endp

rowForward proc
        mov cl, table[bx+2]
        cmp cl,player[0]
        je f1
        jmp fin
        f1:
            mov cl, table[bx+9]
            cmp cl, player[0]
            je f2
            jmp fin
        f2: 
            mov cl, table[bx+1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+1],24h
        fin:
ret
rowForward endp

rowBackward proc
        mov cl, table[bx-2]
        cmp cl,player[0]
        je b1
        jmp fin
        b1:
            mov cl, table[bx+7]
            cmp cl, player[0]
            je b2
            jmp fin
        b2: 
            mov cl, table[bx-1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-1],24h
        fin:
ret
rowBackward endp

rowForward2 proc
        mov cl, table[bx-7]
        cmp cl,player[0]
        je f1
        jmp fin
        f1:
            mov cl, table[bx+2]
            cmp cl, player[0]
            je f2
        f2: 
            mov cl, table[bx+1]
            cmp cl, player[0]
            jne captured
        captured:
            mov table[bx+1],24h
        fin:
ret
rowForward2 endp

rowBackward2 proc
        mov cl, table[bx-2]
        cmp cl,player[0]
        je b1
        jmp fin
        b1:
            mov cl, table[bx-9]
            cmp cl, player[0]
            je b2
            jmp fin
        b2: 
            mov cl, table[bx-1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-1],24h
        fin:
ret
rowBackward2 endp

;Procedures for corners
;Corners top
cornerTopLeft1 proc
        mov cl, table[bx-7]
        cmp cl, player[0]
        je continue
        jmp fin
        continue:
            mov cl, table[bx-8]
            cmp cl, player[0] 
            jne captured
            jmp fin
        captured:
            mov table[bx-8],24h
        fin:
ret
cornerTopLeft1 endp

cornerTopLeft2 proc
        mov cl, table[bx+7]
        cmp cl, player[0]
        je continue
        jmp fin
        continue:
            mov cl, table[bx-1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-1],24h
        fin:
ret
cornerTopLeft2 endp

cornerTopRight1 proc
        mov cl, table[bx-9]
        cmp cl, player[0]
        je continue
        jmp fin
        continue:
            mov cl, table[bx-8]
            cmp cl, player[0] 
            jne captured
            jmp fin
        captured:
            mov table[bx-8],24h
        fin:
ret
cornerTopRight1 endp

cornerTopRight2 proc
        mov cl, table[bx+9]
        cmp cl, player[0]
        je continue
        jmp fin
        continue:
            mov cl, table[bx+1]
            cmp cl, player[0] 
            jne captured
            jmp fin
        captured:
            mov table[bx+1],24h
        fin:
ret
cornerTopRight2 endp

;Corners bottoms
cornerBottomLeft1 proc
        mov cl, table[bx+9]
        cmp cl, player[0]
        je continue
        jmp fin
        continue:
            mov cl, table[bx+8]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+8],24h
        fin:
ret
cornerBottomLeft1 endp

cornerBottomLeft2 proc
        mov cl, table[bx-9]
        cmp cl, player[0]
        je continue
        jmp fin
        continue:
            mov cl, table[bx-1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-1],24h
        fin:
ret
cornerBottomLeft2 endp

cornerBottomRight1 proc
        mov cl, table[bx+7]
        cmp cl, player[0]
        je continue
        jmp fin
        continue:
            mov cl, table[bx+8]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+8],24h
        fin:
ret
cornerBottomRight1 endp

cornerBottomRight2 proc
        mov cl, table[bx-7]
        cmp cl, player[0]
        je continue
        jmp fin
        continue:
            mov cl, table[bx+1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+1],24h
        fin:
ret
cornerBottomRight2 endp

checkRow2 proc
        mov cl, table[bx-9]
        cmp cl,player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx-7]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx-8]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-8],24h
        fin:
ret
checkRow2 endp

checkRow2A proc
        mov cl, table[bx+7]
        cmp cl, player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx+16]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx+9]
            cmp cl, player[0]
            je r3
            jmp fin
        r3:
            mov cl, table[bx+8]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+8],24h
        fin:
ret
checkRow2A endp

checkRow7 proc
        mov cl, table[bx+7]
        cmp cl,player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx+9]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx+8]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+8],24h
        fin:
ret
checkRow7 endp

checkRow7A proc
        mov cl, table[bx-9]
        cmp cl, player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx-7]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx-16]
            cmp cl, player[0]
            je r3
            jmp fin
        r3:
            mov cl, table[bx-8]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-8],24h
        fin:
ret
checkRow7A endp

checkCol2 proc
        mov cl, table[bx-9]
        cmp cl,player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx+7]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx-1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-1],24h
        fin:
ret
checkCol2 endp

checkCol2A proc
        mov cl, table[bx-7]
        cmp cl, player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx+9]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx+2]
            cmp cl, player[0]
            je r3
            jmp fin
        r3:
            mov cl, table[bx+1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+1],24h
        fin:
ret
checkCol2A endp

checkCol7 proc
        mov cl, table[bx-7]
        cmp cl,player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx+9]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx+1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+1],24h
        fin:
ret
checkCol7 endp

checkCol7A proc
        mov cl, table[bx-9]
        cmp cl, player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx+7]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx-2]
            cmp cl, player[0]
            je r3
            jmp fin
        r3:
            mov cl, table[bx-1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-1],24h
        fin:
ret
checkCol7A endp

;Center
checkUp proc
        mov cl, table[bx-7]
        cmp cl, player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx-9]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx-16]
            cmp cl, player[0]
            je r3
            jmp fin
        r3:
            mov cl, table[bx-8]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-8],24h
        fin:
ret
checkUp endp

checkDown proc
        mov cl, table[bx+7]
        cmp cl, player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx+9]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx+16]
            cmp cl, player[0]
            je r3
            jmp fin
        r3:
            mov cl, table[bx+8]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+8],24h
        fin:
ret
checkDown endp

checkLeft proc
        mov cl, table[bx-9]
        cmp cl, player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx+7]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx-2]
            cmp cl, player[0]
            je r3
            jmp fin
        r3:
            mov cl, table[bx-1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx-1],24h
        fin:
ret
checkLeft endp

checkRight proc
        mov cl, table[bx-7]
        cmp cl, player[0]
        je r1
        jmp fin
        r1:
            mov cl, table[bx+9]
            cmp cl, player[0]
            je r2
            jmp fin
        r2: 
            mov cl, table[bx+2]
            cmp cl, player[0]
            je r3
            jmp fin
        r3:
            mov cl, table[bx+1]
            cmp cl, player[0]
            jne captured
            jmp fin
        captured:
            mov table[bx+1],24h
        fin:
ret
checkRight endp

end main
