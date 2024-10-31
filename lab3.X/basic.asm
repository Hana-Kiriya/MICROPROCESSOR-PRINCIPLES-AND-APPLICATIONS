List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
	
	;[0x000]
	MOVLW 0xC8
	MOVWF TRISA
	
	RLNCF TRISA, f ; rotate left
	MOVLW 0xFE
	ANDWF TRISA
	;end of rotate left
	
	MOVLW 0x80 ; WREG = 1000 0000
	ANDWF TRISA, w ; store 7th bit at WREG 1000 0000 or 0000 0000
	
	RRNCF TRISA, f ; rotate right
	IORWF TRISA, f ; [0x000] | WREG
	;end of rotate right
end


