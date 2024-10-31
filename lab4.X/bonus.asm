List p=18f4520 ;???PIC18F4520
    ;???PIC18F
    #include<p18f4520.inc>
        CONFIG OSC = INTIO67
        CONFIG WDT = OFF
        org 0x00 ; ???0x00???????
initial:	
	MOVLW 0x09 ;times
	MOVWF 0x010
	MOVLW 0x00
	MOVWF 0x020 ;1st high
	MOVWF 0x021 ;1st low
	MOVWF 0x030 ;2nd high
	MOVLW 0x01
	MOVWF 0x031 ;2nd low
	TSTFSZ 0x010
	    goto dec
	MOVFF 0x020, 0x030
	MOVFF 0x021, 0x031
	goto mov
    
    mov:
	MOVFF 0x030, 0x000 ;final ans store at 0x030 and 0x000, copy to 0x000 and 0x001
	MOVFF 0x031, 0x001
	CLRF 0x020
	CLRF 0x021
	CLRF 0x030
	CLRF 0x031
	goto finish
    dec:
	DECFSZ 0x010 ;start at n = 2, so minus 1
	    rcall fib
	goto mov
    fib:
	MOVF 0x021, w ;1st low store at wreg
	MOVFF 0x031, 0x021 ;this time's 2nd = next time's 1st (low)
	ADDWF 0x031 ;add low
	MOVF 0x020, w ;1st high store at wreg
	MOVFF 0x030, 0x020 ;this time's 2nd = next time's 1st (high)
	ADDWFC 0x030 ;add high + carry from low
	DECFSZ 0x010 ;i--
	    goto fib
	RETURN
    finish:
	NOP
end


