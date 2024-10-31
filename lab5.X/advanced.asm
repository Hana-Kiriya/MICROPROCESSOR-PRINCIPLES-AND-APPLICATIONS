#include "xc.inc"
Global _gcd
PSECT mytext, local, class = CODE, reloc = 2

_gcd:
    MOVFF 0x001, LATB
    MOVFF 0x002, LATA
    MOVFF 0x003, LATD
    MOVFF 0x004, LATC
    rcall check
    MOVFF LATA, 0x002
    MOVFF LATB, 0x001
    RETURN

check:
    MOVF LATB, w
    CPFSGT LATD ;skip next line if LATD > LATB
	rcall change ;run when LATD <= LATB
    MOVF LATA, w
    CPFSGT LATC
	rcall change1;run when LATC <= LATA
    MOVF LATB, w
    CPFSGT  LATD
	rcall check_sub
    SUBWF LATD
    MOVF LATA, w
    SUBWF LATC
    MOVFF LATD, 0x004
    MOVF LATC,w
    ADDWF 0x004
    TSTFSZ 0x004
	GOTO check
    RETURN
    
change:
    MOVF LATC, w
    MOVFF LATA, LATC
    MOVWF LATA
    MOVF LATD, w
    MOVFF LATB, LATD
    MOVWF LATB
    RETURN
    
change1:
    CPFSLT LATC ;skip next line if LATC < LATA
	RETURN;run when LATC = LATA
    MOVF LATC, w
    MOVFF LATA, LATC
    MOVWF LATA
    MOVF LATD, w
    MOVFF LATB, LATD
    MOVWF LATB
    RETURN

check_sub:
    CPFSLT LATD
	RETURN ;run if LATD = LATB
    DECF LATC
    RETURN