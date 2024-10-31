List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
	
	setup:
	    MOVLW 0x06
	    MOVWF 0x000
	    MOVLB 0x1
	    MOVLW 0xFF;0x08
	    MOVWF 0x100 ; [0x100] = 0x08
	    MOVLW 0x87;0x7C
	    MOVWF 0x101
	    MOVLW 0x8C;0x78
	    MOVWF 0x102
	    MOVLW 0xEF;0xFE
	    MOVWF 0x103
	    MOVLW 0x43;0x34
	    MOVWF 0x104
	    MOVLW 0xA7;0x7A
	    MOVWF 0x105
	    MOVLW 0xD1;0x0D
	    MOVWF 0x106
	    
	    LFSR 0, 0x100
	    LFSR 1, 0x106
	runx:
	    LFSR 0, 0x100
	    MOVFF 0x000, 0x001
	    MOVF INDF1,w
	    runy:
		CPFSLT INDF0 ; if INDF0 > INDF1, goto change
		    GOTO change
		MOVF POSTINC0, w
		MOVF INDF1, w
		DECFSZ 0x001
		    GOTO runy
		MOVF POSTDEC1, w
		DECFSZ 0x000
		    GOTO runx
		GOTO fin
	    
	    change:
		MOVFF INDF0, INDF1
		MOVWF POSTINC0
		MOVF INDF1, w
		DECFSZ 0x001
		    GOTO runy
		MOVF POSTDEC1,w
		DECFSZ 0x000
		    GOTO runx
		GOTO fin
	fin:
	    NOP
end


