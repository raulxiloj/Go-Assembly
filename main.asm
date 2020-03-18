include macros.asm 

.model small
;-----Stack segment-----
.stack 100h
;-----Data segment-----
.data
header db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,13,"FACULTAD DE INGENIERIA",10,13,"CIENCIAS Y SISTEMAS",10,13,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1",10,13,"NOMBRE: RAUL XILOJ",10,13,"CARNET: 201612113",10,13,"SECCION: A",10,10,13,36
options db "1) Iniciar juego",10,13,"2) Cargar juego",10,13,"3) Salir",10,13,36
start db "starting game",36
load db "loading game",36
;-----Code segment-----
.code
main proc

        print header
        print options
        menuPrincipal:
                getChar
                cmp al, 31h
                je startGame
                cmp al, 32h
                je loadGame
                cmp al, 33h
                je finishGame
                jmp menuPrincipal

        startGame:
                print start
        loadGame:
                print load
        finishGame:
                mov ah, 4ch
                int 21h

main endp
end main
