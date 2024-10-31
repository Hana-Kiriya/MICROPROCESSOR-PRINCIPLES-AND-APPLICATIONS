List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
 
Run macro a1, a2, a3, b1, b2, b3
    MOVLW a1
    MOVWF 0x030
    MOVLW a2
    MOVWF 0x031
    MOVLW a3
    MOVWF 0x032
    MOVLW b1
    MOVWF 0x033
    MOVLW b2
    MOVWF 0x034
    MOVLW b3
    MOVWF 0x035
    endm
    
R_S macro m0, m1, n0, n1, F
    
    MOVFF m0, 0x000 
    MOVFF m1, 0x001
    MOVFF n0, 0x010 
    MOVFF n1, 0x011
    rcall mul_sub 

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
    Run 0x01, 0x03, 0x06, 0x02, 0x03, 0x05 ;a1, a2, a3, b1, b2, b3
    ;Run 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
    rcall cross
    CLRF 0x030
    CLRF 0x031
    CLRF 0x032
    CLRF 0x033
    CLRF 0x034
    CLRF 0x035
    goto finish
   
mul_sub:
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
    
cross:
    R_S 0x031, 0x032, 0x034, 0x035, 0x020 ;a2, a3, b2, b3
    R_S 0x032, 0x030, 0x035, 0x033, 0x021 ;a3, a1, b3, b1
    R_S 0x030, 0x031, 0x033, 0x034, 0x022 ;a1, a2, b1, b2
    RETURN
    
finish:
    NOP
end


