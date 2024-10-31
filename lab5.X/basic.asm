#include "xc.inc"
Global _mysqrt
PSECT mytext, local, class = CODE, reloc = 2;

 ;8bit => store in wreg
_mysqrt:
    MOVWF LATD
    MOVLW 1
    MOVWF LATA
    rcall run
    MOVF LATA, w
    RETURN
    
run:  
    MULWF LATA
    MOVF PRODL, w
    CPFSGT LATD ;skip if LATD > w
	RETURN ;goto check if (0x010)^2 <= LATD
    BTFSC PRODH, 0
	RETURN
    INCF LATA
    MOVF LATA, w
    MULWF LATA
    goto run