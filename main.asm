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
white     db "W",'$'
black     db "B",'$'
space     db " ",'$'
turn1     db "Turno negras: ",'$'
turn2     db "Turno blancas: ",'$'
inst      db 10 dup('$')
coor      db 2 dup('$'),'$'
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
titleTag  db "      <title> Reporte </title>",10
headEnd   db "</head>",10
bodyInit  db "<body>",10
bodyEnd   db "</body>",10
htmlEnd   db "</html>"
;--------------------------Possibles errors:--------------------------
error     db 10,10,13,"Error: caracter invalido",10,10,13,'$'
error2    db 10,10,13,"Error: comando no reconocido",10,10,13,'$'
error3    db 10,10,13,"Error al abrir archivo",10,10,13,'$'
error4    db 10,10,13,"Error al cerrar archivo",10,10,13,'$'
error5    db 10,10,13,"Error al escribir en el archivo",10,10,13,'$'
error6    db 10,10,13,"Error al crear el archivo",10,10,13,'$'
error7    db 10,10,13,"Error al leer el archivo",10,10,13,'$'
error8    db 10,10,13,"Error: letra no valida",10,10,13,'$'
error9    db 10,10,13,"Error: numero no valido",10,10,13,'$'
error10   db 10,10,13,"Error: moviendo el puntero del fichero",10,10,13,'$'
prueba    db "Esto es una prueba gg",'$'
;----------------------------------------------------------------------------------------------
;-----------------------------------------Code segment-----------------------------------------
;----------------------------------------------------------------------------------------------
.code
main proc
        mov ax, @data
        mov ds,ax
        print header
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
                print turn1 
                getTexto inst
                ;print inst
                ;print newLine
                analizeInst inst
                ;print turn2 
                ;getCoor 
                jmp menuPrincipal
        loadGame:
                print newLine
                print inputFile
                getRuta file
                openFile file,handler
                readFile handler,fileData,SIZEOF fileData
                cleanBuffer file,SIZEOF file,24h
                ;TO DO:charge data to the table then clean
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
                jmp menuPrincipal
        errorNumber:
                print error9
                jmp menuPrincipal
        errorAppending:
                print error10
                jmp menuPrincipal
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


end main
