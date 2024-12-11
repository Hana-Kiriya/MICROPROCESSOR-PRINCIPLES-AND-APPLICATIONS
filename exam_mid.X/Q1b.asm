List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????

	devide macro x1h, x1l, x2, qh, ql, r
	MOVLW x1h
	MOVWF 0x040
	MOVLW x1l
	MOVWF 0x041
	MOVLW x2
	MOVWF 0x042
	run:
	MOVF 0x042, w
	CPFSLT 0x041 ;skip next line if [0x001] < [0x002]
	    GOTO sub_l
	DECF 0x040
	MOVLW 0xFF
	MOVWF 0x043
	MOVF 0x042, w
	SUBWF 0x043, w
	ADDWF 0x041
	INCF 0x041
	MOVLW 0x001
	ADDWF ql
	MOVLW 0x000
	ADDWFC qh 
	MOVFF 0x041, r
	TSTFSZ 0x040
	    GOTO run
	MOVF 0x042, w
	CPFSLT 0x041
	    GOTO run
	GOTO finish
	
    sub_l:
	MOVF 0x042, w 
	SUBWF 0x041
	MOVLW 0x001
	ADDWF ql
	MOVLW 0x000
	ADDWFC qh 
	MOVFF 0x041, r
	TSTFSZ 0x040
	    GOTO run
	MOVF 0x042, w
	CPFSLT 0x041
	    GOTO run
	GOTO finish
	
    finish:
	NOP
	endm
	
    Fact macro n , k, ans
	MOVLW n
	MOVWF 0x010 ;n
	MOVLW k
	MOVWF 0x011 ;k
	MOVFF 0x010, 0x012
	SUBWF 0x012 ; n - k
	CLRF 0x020
	CLRF 0x021
	MOVLW 0x001
	MOVWF 0x021
	MOVWF 0x022
	MOVLW 0x001
	MOVWF PRODL
	CLRF PRODH
    mul_n_devide_k:
	MOVF 0x020, w
	MULWF 0x010
	MOVFF PRODL, 0x020
	MOVF 0x021, w
	MULWF 0x010
	MOVFF PRODL, 0x021
	MOVF PRODH, w
	ADDWF 0x020
	DECF 0x010
	MOVF 0x010, w
	CPFSEQ 0x011
	    GOTO mul_n_devide_k
	MOVFF 0x020, 0x030
	MOVFF 0x021, 0x031
	MOVLW 0x001
	MOVWF PRODL
    mul_nk:
	MOVF PRODL, w
	MULWF 0x012
	DECFSZ 0x012
	    GOTO mul_nk
	MOVFF PRODL, 0x022
    
    devide 0x020, 0x021, 0x022, 0x001, 0x000, 0x002
    endm
    
    
    
	
    initial:
	CLRF 0x000
	CLRF 0x010
	CLRF 0x011
	CLRF 0x012
	Fact 0x5, 0x3, 0x000
	CLRF 0x010
	CLRF 0x011
	CLRF 0x012
	CLRF 0x020
	CLRF 0x021
end


