//??????
#include <xc.h>
#include <pic18f4520.h>
#include <stdio.h>

#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON    // Brown-out Reset Enable bit
#pragma config PBADEN = OFF  // Watchdog Timer Enable bit
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

unsigned int duty_cycle = 0;

#define _XTAL_FREQ 1000000   // 1 MHz => 1 �s

void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = (ADRESH << 2) | (ADRESL >> 6); //high-bits ? low bits ?? 16bits
    if(value <= 512) duty_cycle = value / 5 + 5;
    else duty_cycle = (1023 - value) / 5 + 5;
    
    CCPR1L = duty_cycle >> 2;
    CCP1CONbits.DC1B = duty_cycle & 3;
    //do things
    
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    //step5 & go back step3
    //delay at least 2tad
    ADCON0bits.GO = 1;
    
    
    return;
}

void main(void) 
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b100; //1MHz
    TRISAbits.RA0 = 1;       //RA0: analog input port
    
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    
    //step1
    ADCON1bits.VCFG0 = 0;       //?????????
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input
    ADCON2bits.ADCS = 0b000;  //????000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 2 us acquisition time?2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 
    
    
    //step2
    PIE1bits.ADIE = 1; //??ADC??
    PIR1bits.ADIF = 0; //???????
    INTCONbits.PEIE = 1; //??????
    INTCONbits.GIE = 1; //??????

    T2CONbits.TMR2ON = 0b1; //0b1 -> on, 0b0 -> off
    T2CONbits.T2CKPS = 0b01; //0b00 -> prescaler = 1, 0b01 -> prescaler = 4, 0b10 -> prescaler = 16
    
    //PWM set
    PR2 = 0xFF; //PWM ?? => T = (255 + 1) * 4 * 1(�s) * 4(???)
    CCPR1L = 0x00; //??????
    CCP1CONbits.CCP1M = 0b1100; //?? PWM ??
    

    //step3
    ADCON0bits.GO = 1; //??ADC?????????0
    
    //?PWM ??????????LED???????????????(> 100 Hz)??LED?????
    //????(Duty cycle)???? PWM ????active-high?????active-high????????????????LED?????
    while(1);
    
    return;
}

