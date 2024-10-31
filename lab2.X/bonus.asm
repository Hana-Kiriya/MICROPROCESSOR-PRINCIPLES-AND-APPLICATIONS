List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
	
	setup:
	    MOVLW 0x00;0x28
	    MOVWF 0x000 ; [0x000] = 0x28
	    MOVLW 0x11;0x34
	    MOVWF 0x001
	    MOVLW 0x22;0x7A
	    MOVWF 0x002
	    MOVLW 0x33;0x80
	    MOVWF 0x003
	    MOVLW 0x44;0xA7
	    MOVWF 0x004
	    MOVLW 0x55;0xD1
	    MOVWF 0x005
	    MOVLW 0x66;0xFE
	    MOVWF 0x006
	    ;test value
	    MOVLW 0x33
	    MOVWF 0x007
	    
	    MOVLW 0x00
	    MOVWF 0x020 ;L
	    MOVLW 0x06
	    MOVWF 0x021 ;R
	    ADDWF 0x020, w
	    ANDLW 0xFE
	    MOVWF 0x022 
	    RRNCF 0x022 ;mid
	    MOVF 0x022, w ; wreg = 0x03
	    LFSR 0, 0x000
	    MOVF PLUSW0, w ;wreg = [0x000 + 0x003]
	run:
	    CPFSEQ 0x007
		GOTO check
	    MOVLW 0xFF
	    MOVWF 0x011
	    GOTO fin
	    
	check:
	    CPFSGT 0x007 ;if [0x007] > wreg, skip next line, else goto lower
		GOTO lower
	    MOVFF 0x022, 0x020
	    INCF 0x020 ; L = mid + 1
	    MOVF 0x020, w
	    CPFSLT 0x021 ;if [0x020](wreg) > [0x021](f), skip next line
		GOTO cont1
	    GOTO notfound
	cont1:
	    ADDWF 0x021, w ;L + R
	    ANDLW 0xFE
	    MOVWF 0x022 
	    RRNCF 0x022 ;mid
	    MOVF 0x022, w 
	    MOVF PLUSW0, w ;wreg = [0x000 + wreg]
	    GOTO run
	lower:
	    TSTFSZ 0x021
		GOTO still
	    GOTO notfound
	
	still:
	    MOVFF 0x022, 0x021
	    DECF 0x021 ;R = mid - 1
	    MOVF 0x021, w
	    CPFSGT 0x020 ;if [0x021](wreg) < [0x020](f), skip next line
		GOTO cont2
	    GOTO notfound
	cont2:
	    ADDWF 0x020, w
	    ANDLW 0xFE
	    MOVWF 0x022
	    RRNCF 0x022 ;mid
	    MOVF 0x022, w
	    MOVF PLUSW0, w ;wreg = [0x000 + wreg]
	    GOTO run
	
	notfound:
	    MOVLW 0x00
	    MOVWF 0x011
	    GOTO fin
	fin:
	    NOP
end

