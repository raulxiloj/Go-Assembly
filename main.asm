include macros.asm 
include files.asm
include date.asm
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
white     db "W",'$'
black     db "B",'$'
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
prueba    db "Esto es una prueba gg",'$'
temp1     db "Tiene 0 libertades", '$'
temp2     db "Tiene 1 libertad", '$'
temp3     db "Tiene 2 libertades",'$'
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
        finishGame:
                mov ah, 4ch
                int 21h

main endp

;-----Procedures-----
printRowNum proc
        cmp cx, 0
        jne fin
        cmp bx, 0
        je print1
        cmp bx, 1
        je print2
        cmp bx, 2
        je print3
        cmp bx, 3
        je print4
        cmp bx, 4
        je print5
        cmp bx, 5
        je print6
        cmp bx, 6
        je print7
        cmp bx, 7
        je print8
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

end main
