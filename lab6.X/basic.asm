LIST p=18f4520
#include<p18f4520.inc>

    CONFIG OSC = INTIO67 ; Set internal oscillator to 1 MHz
    CONFIG WDT = OFF     ; Disable Watchdog Timer
    CONFIG LVP = OFF     ; Disable Low Voltage Programming

    L1 EQU 0x14         ; Define L1 memory location
    L2 EQU 0x15         ; Define L2 memory location
    org 0x00            ; Set program start address to 0x00

; instruction frequency = 1 MHz / 4 = 0.25 MHz
; instruction time = 1/0.25 = 4 ?s
; Total_cycles = 2 + (2 + 8 * num1 + 3) * num2 cycles
; num1 = 150, num2 = 50, Total_cycles = 62512 cycles
; Total_delay ~= Total_cycles * instruction time = 0.25 s
DELAY macro num1, num2
    local LOOP1         ; Inner loop
    local LOOP2         ; Outer loop
    
    ; 2 cycles
    MOVLW num2          ; Load num2 into WREG
    MOVWF L2            ; Store WREG value into L2
    
    ; Total_cycles for LOOP2 = 2 cycles
    LOOP2:
    MOVLW num1          
    MOVWF L1  
    
    ; Total_cycles for LOOP1 = 8 cycles (6 + 2(BRA))
    LOOP1:
    NOP                 ; busy waiting
    NOP
    NOP
    NOP
    NOP
    DECFSZ L1, 1        ;result store in f
	BRA LOOP1           ; BRA instruction spends 2 cycles ;run while L1 != 0
    
    ; 3 cycles (1 + 2(BRA))
    DECFSZ L2, 1        ; Decrement L2, skip if zero
	BRA LOOP2       ;run while L2 != 0    
endm
	
start:
int:
; let pin can receive digital signal
    MOVLW 0x0f          ; Set ADCON1 register for digital mode 
    MOVWF ADCON1        ; Store WREG value into ADCON1 register
    CLRF PORTB          ; Clear PORTB
    BSF TRISB, 0        ; Set RB0 as input (TRISB = 0000 0001)
    CLRF LATA           ; Clear LATA
    BCF TRISA, 0        ; Set RA0 as output (TRISA = 0000 0000)
    BCF TRISA, 1        ; Set RA1 as output (TRISA = 0000 0000)
    BCF TRISA, 2        ; Set RA2 as output (TRISA = 0000 0000)
; Button check
check_process:          
    BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
	BRA check_process   ; If button is not pressed(0th bit = 1), branch back to check_process
    BRA state1         ; If button is pressed(0th bit = 0), branch to lightup

state0:
    MOVLW 0x00
    MOVWF LATA
    rcall delay_label
stay0:
    BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
	BRA stay0
    BRA state1    
    
state1:
    MOVLW 0x01
    MOVWF LATA
    rcall delay_label
stay1:
    BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
	BRA stay1
    BRA state2  
    
state2:
    MOVLW 0x02
    MOVWF LATA
    rcall delay_label
stay2:
    BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
	BRA stay2
    BRA state3 
  
state3:
    MOVLW 0x04
    MOVWF LATA
    rcall delay_label
stay3:
    BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
	BRA stay3
    BRA state0 
    
delay_label:
    DELAY d'110', d'25'
    RETURN
end





