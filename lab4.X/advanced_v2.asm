List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
 
Run macro a1, a2, a3, b1, b2, b3
    Mul_Sub a2, a3, b2, b3, 0x020 ;a2, a3, b2, b3
    Mul_Sub a3, a1, b3, b1, 0x021 ;a3, a1, b3, b1
    Mul_Sub a1, a2, b1, b2, 0x022 ;a1, a2, b1, b2
    endm
    
Mul_Sub macro m0, m1, n0, n1, F
    
    MOVLW m0
    MOVWF 0x000
    MOVLW m1
    MOVWF 0x001
    MOVLW n0
    MOVWF 0x010
    MOVLW n1 
    MOVWF 0x011
    rcall cross 
    
    
    
    MOVFF 0x005, F
    CLRF 0x000
    CLRF 0x001
    CLRF 0x002
    CLRF 0x003
    CLRF 0x004
    CLRF 0x005
    CLRF 0x010
    CLRF 0x011
    CLRF 0x012
    CLRF 0x013
    endm
    
initial:
    Run 0x0B, 0x00, 0x10, 0x0C, 0x00, 0x06 ;a1, a2, a3, b1, b2, b3
    ;Run 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
    goto finish
   
cross:
    MOVF 0x011, w
    MULWF 0x000
    MOVFF PRODH, 0x002
    MOVFF PRODL, 0x003
    
    MOVF 0x010, w
    MULWF 0x001
    MOVFF PRODH, 0x012
    MOVFF PRODL, 0x013
    
    ;PRODL0 - PRODL1 store at 0x005
    MOVLW 0xFF
    MOVWF 0x005
    MOVF 0x013, w
    SUBWF 0x005 
    INCF 0x005 
    MOVF 0x003, w
    ADDWF 0x005 
    
    ;PRODH0 - PRODH1 store at 0x004
    CLRF 0x004
    MOVLW 0x00
    ADDWFC 0x004
    MOVF 0x002, w
    ADDWF 0x004
    DECF 0x004
    MOVF 0x012, w
    SUBWF 0x004
    
    RETURN
 
finish:
    NOP
end


