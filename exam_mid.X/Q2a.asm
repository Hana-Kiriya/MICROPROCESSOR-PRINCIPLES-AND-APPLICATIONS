List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
	
    store macro x0, x1,x2,x3, x4, x5, x6, x7, x8,x9
	MOVLW x0
	MOVWF 0x300
	MOVLW x1
	MOVWF 0x301
	MOVLW x2
	MOVWF 0x302
	MOVLW x3
	MOVWF 0x303
	MOVLW x4
	MOVWF 0x304
	MOVLW x5
	MOVWF 0x305
	MOVLW x6
	MOVWF 0x306
	MOVLW x7
	MOVWF 0x307
	MOVLW x8
	MOVWF 0x308
	MOVLW x9
	MOVWF 0x309
    endm
    initial:
	MOVLB 0x3
	store 0x65, 0x06, 0x03, 0x65, 0x0C, 0x04, 0xF7, 0x32, 0x50, 0x00
	LFSR 0, 0x300 ; FSR0 point to 0x300
	LFSR 1, 0x300 ; FSR1 point to 0x316
	MOVLW 0x01 ;
	MOVWF 0x310
	MOVWF 0x321
    run:
	MOVLW 0x00
	CPFSGT 0x310
	    GOTO next
	ADDWF PREINC0
	DECFSZ 0x310
	    GOTO run
    next:
	MOVLW 0x06 ;
	MOVWF 0x311
	MOVWF 0x322
    run1:
	MOVLW 0x00
	CPFSGT 0x311
	    GOTO finish
	ADDWF PREINC1
	MOVLW 0x00
	DECFSZ 0x311
	    GOTO run1
    run2:
	MOVFF INDF0, 0x320
	MOVFF INDF1, POSTINC0
	MOVFF 0x320, POSTDEC1
	INCF 0x321
	DECF 0x322
	MOVF 0x321, w
	CPFSGT 0x322
	    GOTO finish
	GOTO run2
	
    finish:
	NOP
end


