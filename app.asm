; ALLOWS ONE TO START THE APPLICATION WITH RUN
; SYS 2064
*=$0801 
         BYTE $0C, $8, $0A, $00, $9E, $20, $32, $30, $36, $34, $00, $00, $00, $00, $00


CHMEMPTR        = $D018 ; CHARACTER MEMORY POINTER TO $3000
CHMAPMEM        = $3000 ; CHARACTER MEMORY POINTER

CPUPORT         = $0001 ; PROCESSOR PORT FLAGS

INIT    
        ; DISABLED INTERRUPTS
        SEI

        ; TURN CHARACTER ROM VISIBLE AT $D000
        LDA CPUPORT
        AND #%11111011
        STA CPUPORT

        ; DEFINE CHAR RAM START $3000
        LDA #$00
        STA $FA
        LDA #$30
        STA $FB

        ; DEFINE CHAR ROM START $D000
        LDA #$00
        STA $FC
        LDA #$D0
        STA $FD

        ; COPY CHARACTERS ROM -> RAM
        LDY #0          ; Y ACTS AS A READ/WRITE LSB OFFSET
CPYLOOP
        LDA ($FC),Y     ; READ BYTE FROM ROM (TO ADDRESS *FD+*FC+Y)
        STA ($FA),Y     ; WRITE BYTE TO RAM (TO ADDRESS *FB+*FA+Y)
        INY             ; WRITE UNTIL Y OVERFLOWS BACK TO ZERO
        BNE CPYLOOP

        LDX $FD         ; INCREMENT ROM READ MSB
        INX
        STX $FD
        LDX $FB         ; INCREMENT RAM WRITE MSB
        INX
        STX $FB
        CPX #$38        ; KEEP COPYING UNTIL AT THE END OF CHAR RAM
        BNE CPYLOOP

        ; TURN I/O BACK VISIBLE AT $D000
        LDA CPUPORT
        ORA #%00000100
        STA CPUPORT

        ; SET CHARACTER MEMORY POINTER
        LDA CHMEMPTR
        AND #%11110000
        ORA #%00001100
        STA CHMEMPTR

        ; RE-ENABLE INTERRUPTS
        CLI

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
