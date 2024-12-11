List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
	
    devide macro x1h, x1l, x2, qh, ql, r
	MOVLW x1h
	MOVWF 0x000
	MOVLW x1l
	MOVWF 0x001
	MOVLW x2
	MOVWF 0x002
	run:
	MOVF 0x002, w
	CPFSLT 0x001 ;skip next line if [0x001] < [0x002]
	    GOTO sub_l
	DECF 0x000
	MOVLW 0xFF
	MOVWF 0x003
	MOVF 0x002, w
	SUBWF 0x003, w
	ADDWF 0x001
	INCF 0x001
	MOVLW 0x001
	ADDWF ql
	MOVLW 0x000
	ADDWFC qh 
	MOVFF 0x001, r
	TSTFSZ 0x000
	    GOTO run
	MOVF 0x002, w
	CPFSLT 0x001
	    GOTO run
	GOTO finish
	
    sub_l:
	MOVF 0x002, w 
	SUBWF 0x001
	MOVLW 0x001
	ADDWF ql
	MOVLW 0x000
	ADDWFC qh 
	MOVFF 0x001, r
	TSTFSZ 0x000
	    GOTO run
	MOVF 0x002, w
	CPFSLT 0x001
	    GOTO run
	GOTO finish
	
    finish:
	NOP
	endm
	
    initial:
	CLRF 0x000
	CLRF 0x001
	CLRF 0x002
	CLRF 0x020
	CLRF 0x021
	CLRF 0x022
	
	devide 0x11, 0x45, 0x14, 0x020, 0x021, 0x022
	CLRF 0x003
end


