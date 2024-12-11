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
	
goto Initial			    
ISR:				
    org 0x08                ; ????: ?0.5??????interrupt
    MOVLW 0x02
    BTFSC 0x032, 0
	SUBWF 0x020 ; if 0th bit = 1, run this
    INCF 0x020
    MOVF 0x031, w
    CPFSLT 0x020
	MOVFF 0x030, 0x020
    MOVFF 0x020, LATA
    BCF PIR1, TMR2IF        ; ??????TMR2IF?? (??flag bit)
    RETFIE
    
Initial:	
    ;0.5s
    ; set Prescale and Postscale = 1:16?means every 256 T passed the TIMER2+1
    ; but TIMER is count by frequence / 4
    ; so only when pass 256 * 4 = 1024 cycles, the TIMER2 + 1
    ; if it is 250khz?want Delay 0.5s? means while pass 125000 cycles run Interrupt once
    ; so PR2 should set 125000 / 1024 = 122.0703125? choose 122?
    MOVLW 0x0F
    MOVWF ADCON1
    CLRF TRISA
    CLRF LATA
    BCF TRISA, 0        ; Set RA0 as output (TRISA = 0000 0000)
    BCF TRISA, 1        ; Set RA1 as output (TRISA = 0000 0000)
    BCF TRISA, 2        ; Set RA2 as output (TRISA = 0000 0000)
    BCF TRISA, 3        ; Set RA3 as output (TRISA = 0000 0000)
    CLRF PORTB          ; Clear PORTB
    BSF TRISB,  0	 ; set RB0 = 1
    BSF RCON, IPEN
    BSF INTCON, GIE
    BCF PIR1, TMR2IF		; for using TIMER2?set TMR2IF?TMR2IE?TMR2IP?
    BSF IPR1, TMR2IP
    BSF PIE1 , TMR2IE
    MOVLW b'11111111'	        
    MOVWF T2CON		
    MOVLW D'61'		
    MOVWF PR2			
    
    CLRF 0x020 ; store ans
    CLRF 0x021 ; store state
    CLRF 0x032 ; check dec if 0th bit = 1 => sub 2
    
    MOVLW D'00100000'
    MOVWF OSCCON	        ; set 250kHz
    
main:
    CLRF 0x020
    MOVLW 0x00
    MOVWF 0x030
    CLRF 0x032
    MOVLW 0x08
    MOVWF 0x031
    MOVFF 0x030, 0x020
    MOVFF 0x020, LATA
    GOTO s1
    bra main	    

;0.25s
s1: 
    MOVLW 0x01
    MOVWF 0x021
    BTFSS PORTB, 0		; Check if PORTB bit 0 is high (button not pressed)
	GOTO change		; if button is press (bit 0 = 0), GOTO s2
    MOVLW D'61'		; 250000 / 4 = 62500 => 62500 / 1024 = 61
    MOVWF PR2	
    GOTO s1
    
;0.5s
s2:
    MOVLW 0x02
    MOVWF 0x021
    BTFSS PORTB, 0		; Check if PORTB bit 0 is high (button not pressed)
	GOTO change		; if button is press (bit 0 = 0), GOTO s3
    MOVLW D'122'		; 250000 / 2 = 62500 => 125000 / 1024 = 122
    MOVWF PR2	
    GOTO s2
    
;0.25s
s3:
    MOVLW 0x03
    MOVWF 0x021
    BTFSS PORTB, 0		; Check if PORTB bit 0 is high (button not pressed)
	GOTO change		; if button is press (bit 0 = 0), GOTO s4
    MOVLW D'61'		; 250000 / 4 = 62500 => 62500 / 1024 = 61
    MOVWF PR2	
    GOTO s3

;0.5s
s4:
    MOVLW 0x04
    MOVWF 0x021
    BTFSS PORTB, 0		; Check if PORTB bit 0 is high (button not pressed)
	GOTO change		; if button is press (bit 0 = 0), GOTO s5
    MOVLW D'122'		; 250000 / 2 = 62500 => 125000 / 1024 = 122
    MOVWF PR2	
    GOTO s4

;0.25s
s5:
    MOVLW 0x05
    MOVWF 0x021
    BTFSS PORTB, 0		; Check if PORTB bit 0 is high (button not pressed)
	GOTO change		; if button is press (bit 0 = 0), GOTO s6
    MOVLW D'61'		; 250000 / 4 = 62500 => 62500 / 1024 = 61
    MOVWF PR2	
    GOTO s5

;0.5s
s6:
    MOVLW 0x06
    MOVWF 0x021
    BTFSS PORTB, 0		; Check if PORTB bit 0 is high (button not pressed)
	GOTO change		; if button is press (bit 0 = 0), GOTO s1
    MOVLW D'122'		; 250000 / 2 = 62500 => 125000 / 1024 = 122
    MOVWF PR2	
    GOTO s6
  
change:
    BCF PIE1, TMR2IE      ; cleat TMR2IE, stopping Timer2
    MOVLW 0x01
    MOVWF TMR2
    MOVLW 0x06
    CPFSLT 0x021
	GOTO c_6_t_1
    MOVLW 0x05
    CPFSLT 0x021
	GOTO c_5_t_6
    MOVLW 0x04
    CPFSLT 0x021
	GOTO c_4_t_5
    MOVLW 0x03
    CPFSLT 0x021
	GOTO c_3_t_4
    MOVLW 0x02
    CPFSLT 0x021
	GOTO c_2_t_3
    MOVLW 0x01
    CPFSLT 0x021
	GOTO c_1_t_2

c_1_t_2:
    CLRF 0x020
    MOVLW 0x00
    MOVWF 0x030
    CLRF 0x032
    MOVLW 0x10
    MOVWF 0x031
    MOVFF 0x030, 0x020
    MOVFF 0x020, LATA
    
    MOVLW D'122'		
    MOVWF PR2			
    BSF PIE1, TMR2IE		; set TMR2IE, start Timer2
    DELAY  d'350' , d'90'	; Delay0.25s
    GOTO s2

c_2_t_3:
    MOVLW 0x0F
    MOVWF 0x030
    MOVLW 0x01
    MOVWF 0x032
    MOVLW 0xFF
    MOVWF 0x031
    MOVFF 0x030, 0x020
    MOVFF 0x020, LATA
    
    MOVLW D'61'		
    MOVWF PR2			; add wait 0s
    BSF PIE1, TMR2IE		; set TMR2IE, start Timer2
    DELAY  d'350' , d'90'	; Delay0.25s
    GOTO s3
    
c_3_t_4:
    CLRF 0x020
    MOVLW 0x00
    MOVWF 0x030
    CLRF 0x032
    MOVLW 0x08
    MOVWF 0x031
    MOVFF 0x030, 0x020
    MOVFF 0x020, LATA
    
    MOVLW D'122'		
    MOVWF PR2			; add wait 0.25s
    BSF PIE1, TMR2IE		; set TMR2IE, start Timer2
    DELAY  d'350' , d'90'	; Delay0.25s
    GOTO s4

c_4_t_5:
    CLRF 0x020
    MOVLW 0x00
    MOVWF 0x030
    CLRF 0x032
    MOVLW 0x10
    MOVWF 0x031
    MOVFF 0x030, 0x020
    MOVFF 0x020, LATA
    
    MOVLW D'61'		
    MOVWF PR2			; add wait 0s
    BSF PIE1, TMR2IE		; set TMR2IE, start Timer2
    DELAY  d'350' , d'90'	; Delay0.25s
    GOTO s5

c_5_t_6:
    MOVLW 0x0F
    MOVWF 0x030
    MOVLW 0x01
    MOVWF 0x032
    MOVLW 0xFF
    MOVWF 0x031
    MOVFF 0x030, 0x020
    MOVFF 0x020, LATA
    
    MOVLW D'122'		
    MOVWF PR2			; add wait 0.25s
    BSF PIE1, TMR2IE		; set TMR2IE, start Timer2
    DELAY  d'350' , d'90'	; Delay0.25s
    GOTO s6
    
c_6_t_1:
    CLRF 0x020
    MOVLW 0x00
    MOVWF 0x030
    CLRF 0x032
    MOVLW 0x08
    MOVWF 0x031
    MOVFF 0x030, 0x020
    MOVFF 0x020, LATA
    DELAY  d'350' , d'75'	; Delay0.25s
    MOVLW D'61'		
    MOVWF PR2			; add wait 0s
    BSF PIE1, TMR2IE		; set TMR2IE, start Timer2
    GOTO s1
end