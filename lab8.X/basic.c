#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

#define _XTAL_FREQ 125000
//__delay_ms(x) = x * 1000 * Fosc / 4
unsigned char state = 0;

void __interrupt() ISR(){
    if(INTCONbits.INT0IF){
        switch(state){
        case 0:
            //degree -90 -> 0
            /**
            * Duty cycle :
            * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
            * = (0x0b*4 + 0b01) * 8탎 * 4 = (d'11 * 4 + d'1) * 8탎 * 4 = d'45 * 32탎
            * = 0.001440s ~= 1440탎
            */
            CCPR1L = 0x0b; // = d'11
            CCP1CONbits.DC1B = 0b01; // = d'1
            state = 1;
            break;
        case 1:
            //degree 0 -> 90
            /**
            * Duty cycle :
            * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
            * = (0x13*4 + 0b00) * 8탎 * 4 = (d'19 * 4 + d'0) * 8탎 * 4 = d'76 * 32탎
            * = 0.002432s ~= 2432탎
            */
            CCPR1L = 0x13; // = d'18
            CCP1CONbits.DC1B = 0b00; // = d'3
            state = 2;
            break;
        case 2:
            //degree 90 -> 0
            /**
            * Duty cycle :
            * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
            * = (0x0b*4 + 0b01) * 8탎 * 4 = (d'11 * 4 + d'1) * 8탎 * 4 = d'45 * 32탎
            * = 0.001440s ~= 1440탎
            */
            CCPR1L = 0x0b; // = d'11
            CCP1CONbits.DC1B = 0b01; // = d'1
            state = 3;
            break;
        case 3:
            //degree 0 -> -90
            /**
            * Duty cycle :degree = -90
            * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
            * = (0x03*4 + 0b11) * 8탎 * 4 = (d'3 * 4 + d'3) * 8탎 * 4 = d'15 * 32탎
            * = 0.000480s ~= 480탎
            */
            CCPR1L = 0x03; // = d'3
            CCP1CONbits.DC1B = 0b11; // = d'3
            state = 0;
            break;
        }
        __delay_ms(250); //250 * 1000 * 125000 / 4 => 0.25s //bouncing problem
        INTCONbits.INT0IF = 0; //clear flag
    }
    
}
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
    
    TRISBbits.TRISB0 = 1; //set INT0/RB0 being input
    INTCON2bits.INTEDG0 = 0; //set INT0 being falling edge trigger (push button)
    INTCONbits.INT0IF = 0; //clear INT0 interrupt flag
    INTCONbits.INT0IE = 1; //enable INT0 interrupt
    INTCONbits.GIE = 1; //enable global interrupt
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8탎 * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    
    /**
     * Duty cycle :degree = -90
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x03*4 + 0b11) * 8탎 * 4 = (d'3 * 4 + d'3) * 8탎 * 4 = d'15 * 32탎
     * = 0.000480s ~= 480탎
     */
    CCPR1L = 0x03; // = d'3
    CCP1CONbits.DC1B = 0b11; // = d'3
    state = 0;
    // initial -----------------------------------------------------------------
    
    while(1);
    return;
}

