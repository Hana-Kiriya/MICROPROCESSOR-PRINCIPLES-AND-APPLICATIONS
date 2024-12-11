#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

void main(void)
{
    // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1; //0b1 -> on, 0b0 -> off
    T2CONbits.T2CKPS = 0b01; //0b00 -> prescaler = 1, 0b01 -> prescaler = 4, 0b10 -> prescaler = 16

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 탎
    //0b000 -> 31kHz, 0b001 -> 125kHz, 0b010 -> 250kHz, 0b011 -> 500kHz, 0b100 -> 1MHz, 0b101 -> 2MHz, 0b110 -> 4MHz, 0b111 -> 8MHz
    OSCCONbits.IRCF = 0b001; 
    
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    //0b0000 -> CCP close, 0b0011 ~ 0b0111 -> catch mode, 0b0010 + 0b1000 ~ 0b1011 -> compare mode, 0b1100 ~ 0b1111 -> PWM mode
    CCP1CONbits.CCP1M = 0b1100;
    
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8탎 * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8탎 * 4
     * = 0.00144s ~= 1450탎
     */
    CCPR1L = 0x0b; // = d'11
    CCP1CONbits.DC1B = 0b01; // = d'1
    
    while(1);
    return;
}

