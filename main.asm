include macros.asm 

.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header   db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,13,"FACULTAD DE INGENIERIA",10,13,"CIENCIAS Y SISTEMAS",10,13,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,13,"NOMBRE: RAUL XILOJ",10,13,"CARNET: 201612113",10,13,"SECCION: A",10,10,13,'$'
options  db "1) Iniciar juego",10,13,"2) Cargar juego",10,13,"3) Salir",10,13,"Ingrese una opcion: ",'$'
table    db 64 dup('$'),'$'
filas    db 1h,2h,3h,4h,5h,6h,7h,8h
columnas db 'A','B','C','D','E','F','G','H'
newLine  db 10,'$'
dash     db "---",'$' 
wall     db "|   |   |   |   |   |   |   |",10,13,'$'
white    db "W",'$'
black    db "B",'$'
space    db " ",'$'
load     db "loading game",'$'
;-----Code segment-----
.code
main proc

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
                jmp menuPrincipal

        startGame:
                print newLine
                showTable table,dash,wall,black,white,space,newLine
                jmp menuPrincipal
        loadGame:
                print load
        finishGame:
                mov ah, 4ch
                int 21h

main endp

end main
