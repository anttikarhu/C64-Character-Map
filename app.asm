; ALLOWS ONE TO START THE APPLICATION WITH RUN
; SYS 2064
*=$0801 
         BYTE $0C, $8, $0A, $00, $9E, $20, $32, $30, $36, $34, $00, $00, $00, $00, $00


CHROMMEM        = $D000 ; CHARACTER ROM ADDRESS

CHMEMPTR        = $D018 ; CHARACTER MEMORY POINTER TO $3000
CHMAPMEM        = $3000 ; CHARACTER MEMORY POINTER

TMRCTRLA        = $DC0E ; TIMER A CONTROL REGISTER

CPUPORT         = $0001 ; PROCESSOR PORT FLAGS

INIT    
        ; SET CHARACTER MEMORY POINTER
        LDA CHMEMPTR
        AND #%11110000
        ORA #%00001100
        STA CHMEMPTR

        ; TURN OFF KEYSCAN INTERRUPT TIMER
        LDA TMRCTRLA
        AND #%11111110
        STA TMRCTRLA

        ; TURN CHARACTER ROM VISIBLE AT $D000
        LDA CPUPORT
        AND #%11111011
        STA CPUPORT

        ; COPY SOME CHARACTERS ROM -> RAM. NOT ALL CHARACTERS ARE COPIED.
        LDX #0
CPYLOOP LDA CHROMMEM,X
        STA CHMAPMEM,X
        INX
        CPX #255
        BNE CPYLOOP

        ; TURN I/O BACK VISIBLE AT $D000
        LDA CPUPORT
        ORA #%00000100
        STA CPUPORT

        ; RESTART KEYSCAN INTERRUPT TIMER
        LDA TMRCTRLA
        ORA #%00000001
        STA TMRCTRLA

        ; REPLACE LETTER A WITH SMILEY
        LDX #0
LDCHMAP LDA CHMAP,X
        STA $3008,X
        INX
        CPX #8
        BNE LDCHMAP

        ; MAIN LOOP
LOOP    JMP LOOP

        ; CHARACTER MAP
CHMAP   BYTE    0,102,102,0,0,66,66,60
