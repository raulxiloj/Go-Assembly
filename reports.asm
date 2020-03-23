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
    writeFile handler,  css, SIZEOF css
    seekEnd handler
    writeFile handler,  css2, SIZEOF css2
    seekEnd handler
    writeFile handler,  css3, SIZEOF css3
    seekEnd handler
    writeFile handler, headEnd, SIZEOF headEnd
    seekEnd handler
    writeFile handler, bodyInit, SIZEOF bodyInit
    seekEnd handler
    ;Tablero (divs)
    writeFile handler, divTable, SIZEOF divTable
    seekEnd handler
    ;row1
    writeFile handler, divr1, SIZEOF divr1
    seekEnd handler
    ;TODO cols of row1
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row2
    writeFile handler, divr2, SIZEOF divr2
    seekEnd handler
    ;TODO cols of row2
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row3
    writeFile handler, divr3, SIZEOF divr3
    seekEnd handler
    ;TODO cols of row3
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row4
    writeFile handler, divr4, SIZEOF divr4
    seekEnd handler
    ;TODO cols of row4
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row5
    writeFile handler, divr5, SIZEOF divr5
    seekEnd handler
    ;TODO cols of row5
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row6
    writeFile handler, divr6, SIZEOF divr6
    seekEnd handler
    ;TODO cols of row6
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row7
    writeFile handler, divr7, SIZEOF divr7
    seekEnd handler
    ;TODO cols of row7
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;row8
    writeFile handler, divr8, SIZEOF divr8
    seekEnd handler
    ;TODO cols of row8
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    ;--------------
    writeFile handler, divEnd, SIZEOF divEnd
    seekEnd handler
    writeFile handler, bodyEnd, SIZEOF bodyEnd
    seekEnd handler
    writeFile handler, htmlEnd, SIZEOF htmlEnd
    closeFile handler 
endm

