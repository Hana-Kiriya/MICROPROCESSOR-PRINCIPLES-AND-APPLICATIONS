List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
    
    Sub_Mul macro xh, xl, yh, yl
        ;sub low
        MOVLW 0xFF
        MOVWF 0x001
        MOVLW yl
        SUBWF 0x001 ;0xFF - yl
        INCF 0x001 ;0xFF - yl + 0x01
        MOVLW xl
        ADDWF 0x001 ;0xFF - yl + 0x01 + xl
        
        ;if xl >= yl, not need sub with carry, so carry of (0xFF - yl + 0x01 + xl) = 0
        ;else need sub with carry, so carry of (0xFF - yl + 0x01 + xl) = 0
        MOVLW 0x00
        ADDWFC 0x000
        MOVLW xh
        ADDWF 0x000
        ;0x001 borrow the carry  before, so minus 1 (if xl - yl not need carry, line 21 added 1, else added 0)
        DECF 0x000
        MOVLW yh
        SUBWF 0x000
        
        
        MOVF 0x000, w
        MULWF 0x001 ;w mul F store at PRODH and PRODL
        MOVF PRODH,w
        MOVWF 0x010
        MOVF PRODL, w
        MOVWF 0x011
        endm
    start:
    Sub_Mul 0x03, 0xA5, 0x02, 0xA7
    ;Sub_Mul 0x02, 0x0C, 0x00, 0x0F
end