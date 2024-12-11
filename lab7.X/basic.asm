#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

    L1 EQU 0x14
    L2 EQU 0x15
    org 0x00
DELAY macro num1, num2 
    local LOOP1 
    local LOOP2
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1
	MOVWF L1
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1
	BRA LOOP2
endm
	
DELAY1 macro num1, num2 
    local LOOP1 
    local LOOP2
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1
	MOVWF L1
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	TSTFSZ 0x030
	    GOTO main
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1
	BRA LOOP2
endm
	
; ??????????main??????????RB0???????interrupt???ISR??
; ISR??????????RA?????Delay?0.5?????

goto Initial			; ????????????ISR????????
org 0x008	
ISR:				; Interrupt????????????
    MOVLW 0x01
    MOVWF 0x030
    CLRF 0x020
    CLRF 0x031
    CLRF LATA
    MOVLW 0x03
    CPFSLT 0x021
	MOVFF 0x031, 0x021
    INCF 0x021
    DELAY  d'350' , d'180'	; ?500_000cycles?? ?1MHz???????Delay0.5?
    BCF INTCON, INT0IF
    RETFIE                    ; ??ISR?????????????????GIE??1??????interrupt????
    
    
Initial:				; ????????
    MOVLW 0x0F
    MOVWF ADCON1		; ???????????Digitial I/O 
    
    CLRF TRISA
    CLRF LATA           ; Clear LATA
    BCF TRISA, 0        ; Set RA0 as output (TRISA = 0000 0000)
    BCF TRISA, 1        ; Set RA1 as output (TRISA = 0000 0000)
    BCF TRISA, 2        ; Set RA2 as output (TRISA = 0000 0000)
    BCF TRISA, 3       ; Set RA2 as output (TRISA = 0000 0000)
    CLRF PORTB          ; Clear PORTB
    BSF TRISB,  0
    BCF RCON, IPEN
    BCF INTCON, INT0IF		; ??Interrupt flag bit??
    BSF INTCON, GIE		; ?Global interrupt enable bit??
    BSF INTCON, INT0IE		; ?interrupt0 enable bit ?? (INT0?RB0 pin?????)
    CLRF 0x020 ;store ans
    CLRF 0x021 ;store state
    CLRF 0x030
    CLRF 0x031

main:
    CLRF 0x020
    CLRF 0x030
    MOVLW 0x03
    CPFSLT 0x021
	GOTO s3
    MOVLW 0x02
    CPFSLT 0x021
	GOTO s2
    MOVLW 0x01
    CPFSLT 0x021
	GOTO s1
    bra main
    
s1: 
    INCF 0x020
    MOVLW 0x04
    CPFSLT 0x020
	GOTO clear1
    MOVFF 0x020, LATA
    DELAY1  d'350' , d'180' ;0.5s
    GOTO s1
    
s2:
    INCF 0x020
    MOVLW 0x08
    CPFSLT 0x020
	GOTO clear2
    MOVFF 0x020, LATA
    DELAY1  d'350' , d'180' ;0.5s
    GOTO s2
    
s3:
    INCF 0x020
    MOVLW 0x10
    CPFSLT 0x020
	GOTO clear3
    MOVFF 0x020, LATA
    DELAY1  d'350' , d'180' ;0.5s
    GOTO s3
    
clear1:
    MOVLW 0x00
    MOVWF 0x020
    MOVFF 0x020, LATA
    DELAY1  d'350' , d'180' ;0.5s
    GOTO stay
    
clear2:
    MOVLW 0x00
    MOVWF 0x020
    MOVFF 0x020, LATA
    DELAY1  d'350' , d'180' ;0.5s
    GOTO stay
    
clear3:
    MOVLW 0x00
    MOVWF 0x020
    MOVFF 0x020, LATA
    DELAY1  d'350' , d'180' ;0.5s
    GOTO stay

stay:
    DELAY1  d'350' , d'180' ;0.5s
    GOTO stay
end