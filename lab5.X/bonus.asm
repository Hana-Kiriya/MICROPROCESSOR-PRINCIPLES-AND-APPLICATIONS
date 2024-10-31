#include "xc.inc"
Global _multi_signed
PSECT mytext, local, class = CODE, reloc = 2

_multi_signed:
    MOVWF LATD //1 byte (char) first store at wreg
    MOVFF 0x001, 0x002
    MOVLW 0x00
    MOVWF PRODL ;ans_l
    MOVWF PRODH ;ans_h
    MOVWF LATB ;signed //0 or 2 => pos, 1 => neg
    MOVWF LATC 
    MOVLW 0x08
    MOVWF LATA ;rotate times
    ;LATC, LATD -> 16 bits will be rotated
    BTFSC LATD, 7 ;skip next line if 7th bit = 0
	rcall comple1 ;goto if 7th bit = 1
    BTFSC 0x002, 7
	rcall comple2
    rcall count
    BTFSC LATB, 0 ;skip next line if 0th bit = 0
	rcall comple0 ;goto if 7th bit = 1
    MOVFF PRODL, 0x001
    MOVFF PRODH, 0x002
    RETURN

comple1:
    INCF LATB
    COMF LATD
    INCF LATD
    RETURN
    
comple2:
    INCF LATB
    COMF 0x002
    INCF 0x002
    RETURN
    
comple0: ;PRODH, PRODL always pos, so if sign = 1, find 2's complement
    COMF PRODL
    MOVLW 0x01
    ADDWF PRODL
    COMF PRODH
    MOVLW 0x00
    ADDWFC PRODH
    RETURN
    
count:
    BTFSC 0x002, 0
	rcall add_num
    RLCF LATD
    RLNCF LATC
    MOVLW 0xFE
    ANDWF LATC
    MOVLW 0x00
    ADDWFC LATC
    RRNCF 0x002
    MOVLW 0x7F
    ANDWF 0x002
    DECFSZ LATA
	GOTO count
    RETURN
    
add_num:
    MOVF LATD, w
    ADDWF PRODL
    MOVF LATC, w
    ADDWFC PRODH
    RETURN