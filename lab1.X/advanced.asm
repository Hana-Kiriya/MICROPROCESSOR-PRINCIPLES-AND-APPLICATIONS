List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
    ;[0x000]
    MOVLW 0xF7;b'01010101'
    MOVWF 0x000
    ANDLW 0xF0
    MOVWF 0x002
    ;[0x001]
    MOVLW 0x9F;b'01111101'
    MOVWF 0x001
    ANDLW 0x0F
    ;[0x002]
    IORWF 0x002, w
    MOVWF 0x002
    MOVLW 0x08
    MOVWF 0x010
    CLRF 0x003
    run:
	BTFSS 0x002, 0
	    INCF 0x003 ;if 0th bit = 1, skip this line
	RRNCF 0x002
	DECFSZ 0x010
	    GOTO run    
	NOP
end


