List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
	
	MOVLW 0xFF
	MOVWF 0x000
	MOVWF 0x010
	MOVLW 0xF1
	MOVWF 0x001
	MOVWF 0x011
	MOVLW 0x08
	MOVWF 0x020
	MOVWF 0x021
	MOVLW 0x0F
	MOVWF 0x002
    testmin1:
	BTFSC 0x010, 7
	    GOTO check1 ;if 7th bit = 0, skip this line. Else if 7th bit = 1, goto check1.
	DECF 0x002
	RLNCF 0x010
	
	DCFSNZ 0x020
	    GOTO testmin2 ;if [0x020] != 0, skip this line. Else if [0x020] = 0, goto testmin2.
	GOTO testmin1
    testmin2:
	BTFSC 0x011, 7
	    GOTO check2 ;if 7th bit = 0, skip this line. Else if 7th bit = 1, goto check2.
	DECF 0x002
	RLNCF 0x011

	DCFSNZ 0x021
	    GOTO fin ;if [0x021] != 0, skip this line. Else if [0x021] = 0, goto fin.
	GOTO testmin2
    
    check1:
	DCFSNZ 0x020
	    GOTO check1_1 ;if [0x020] != 0, skip this line. Else if [0x020] = 0, goto check1_1.
	BTFSC 0x010, 6
	    GOTO up ;if 6th bit = 0, skip this line. Else if 6th bit = 1, goto up.
	RLNCF 0x010
	
	GOTO check1
	
    check1_1:	

	BTFSC 0x011, 7
	    GOTO up ;if 7th bit = 0, skip this line. Else if 7th bit = 1, goto up.
	RLNCF 0x011

	DCFSNZ 0x021
	    GOTO fin ;if [0x021] != 0, skip this line. Else if [0x021] = 0, goto fin.
	GOTO check1_1
	
    check2:
	DCFSNZ 0x021
	    GOTO fin ;if [0x021] != 0, skip this line. Else if [0x020] = 0, goto fin.
	BTFSC 0x011, 6
	    GOTO up ;if 6th bit = 0, skip this line. Else if 6th bit = 1, goto up.
	RLNCF 0x011
	GOTO check2
    up:  
	INCF 0x002
	GOTO fin
    fin:
	CLRF 0x010
	CLRF 0x011
	CLRF 0x020
	CLRF 0x021
	NOP
end


