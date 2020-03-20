open macro file,handler
    mov ah,3dh
    mov al,010b
    lea dx,file
    int 21h
    jc errorOpening
    mov handler, ax
endm

read macro handler,fileData,numBytes
    mov ah,3fh
    mov bx, handler
    mov cx, numBytes
    lea dx, fileData
    int 21h
    jc errorReading
endm


close macro handler
    mov ah,3eh
    mov bx, handler
    int 21h
endm