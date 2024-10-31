List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
    ;A
    MOVLW 0x1F
    MOVWF 0x000
    ;B
    MOVLW 0x01
    MOVWF 0x001
    ;A1
    ADDWF 0x000, w
    MOVWF 0x002
    ;C
    MOVLW 0x7F
    MOVWF 0x010
    ;D
    MOVLW 0x6F
    MOVWF 0x011
    ;A2
    SUBWF 0x010, w
    MOVWF 0x012
    CPFSEQ 0x002
    ;if [0x002] = [0x012], skip next line
	GOTO checkGreat
    MOVLW 0xBB
    MOVWF 0x020
    GOTO fin
    
    checkGreat:
	CPFSGT 0x002
	;if [0x002] > [0x012], skip next line
	    GOTO less
	MOVLW 0xAA
	MOVWF 0x020
	GOTO fin
	
    less:
	MOVLW 0xCC
	MOVWF 0x020
    fin:
	NOP
end