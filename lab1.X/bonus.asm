List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
    ;[0x000]
    MOVLW 0xAA
    MOVWF 0x000
    ;[0x010]
    MOVLW 0x10
    MOVWF 0x010
    
    MOVF 0x000, w
    run:
	BTFSC 0x000, 0
	    GOTO decrease ;if 0th bit = 0, skip this, else, 0th bit = 1 (% 2 = 1), goto decrease
	BTFSS 0x000, 1
	    INCF 0x010 ;if 0th bit = 1 (% 2 = 0, % 4 = 2), skip this, else, 0th bit = 0, [0x010] + 1
	INCF 0x010
	GOTO fin
    decrease:
	DECF 0x010
	GOTO fin
    fin:  
	RRNCF 0x000
	CPFSEQ 0x000
	    GOTO run
	NOP
end


