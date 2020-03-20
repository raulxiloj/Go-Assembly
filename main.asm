include macros.asm 

.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header   db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,13,"FACULTAD DE INGENIERIA",10,13,"CIENCIAS Y SISTEMAS",10,13,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,13,"NOMBRE: RAUL XILOJ",10,13,"CARNET: 201612113",10,13,"SECCION: A",10,10,13,'$'
options  db "1) Iniciar juego",10,13,"2) Cargar juego",10,13,"3) Salir",10,13,"Ingrese una opcion: ",'$'
table    db 64 dup('$'),'$'
row      db "  ",'$' 
columns  db "  A   B   C   D   E   F   G   H",10,10,13,'$'
newLine  db 10,'$'
dash     db "---",'$' 
wall     db "  |   |   |   |   |   |   |   |",10,13,'$'
white    db "W",'$'
black    db "B",'$'
space    db " ",'$'
error    db 10,10,13,"Error: caracter invalido",10,10,13,'$'
load     db "loading game",'$'

;-----Code segment-----
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
                jmp menuPrincipal
        loadGame:
                print load
                jmp menuPrincipal
        invalidChar:
                print error
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

printLetters proc
        print columns
ret
printLetters endp

end main
