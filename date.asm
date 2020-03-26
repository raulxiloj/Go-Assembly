;Macro para obtener el tiempo actual del sistema
getTime macro
        mov ah, 2ch    ;get the current system time
        int 21h
        ;hour
        mov al, ch      
        call convert
        mov time[0],ah
        mov time[1],al
        ;minutes
        mov al,cl
        call convert
        mov time[3],ah
        mov time[4],al
        ;seconds
        mov al, dh
        call convert
        mov time[6],ah
        mov time[7],al
endm

;Macro para obtener la fecha actual del sistema
getDate macro
    mov ah,2ah
    int 21h
    ;day
    mov al, dl 
    call convert
    mov date[0], ah
    mov date[1], al
    ;month
    mov al, dh
    call convert
    mov date[3], ah
    mov date[4], al
    ;year
    ;mov year, cx
endm 
