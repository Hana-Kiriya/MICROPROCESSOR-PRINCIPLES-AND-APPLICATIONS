List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????

    setup:
	MOVLW 0x15
	MOVWF 0x000
	MOVLB 0x1
	MOVLW 0x01;0x00
	MOVWF 0x100
	MOVLW 0x00;0x01
	MOVWF 0x116
	LFSR 0, 0x100 ; FSR0 point to 0x100
	LFSR 1, 0x116 ; FSR1 point to 0x116
    run:
	ADDWF POSTINC0, w
	MOVWF INDF0

	DCFSNZ 0x000 ;if [0x200] != 0, skip next line => if [0x200] = 0, goto fin
	    GOTO fin
	    
	ADDWF POSTDEC1, w
	MOVWF INDF1

	DCFSNZ 0x000 ;if [0x200] != 0, skip next line => if [0x200] = 0, goto fin
	    GOTO fin
	GOTO run
    fin:
	NOP
end

