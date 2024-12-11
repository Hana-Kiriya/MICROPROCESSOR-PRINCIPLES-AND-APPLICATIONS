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

const unsigned char A[] = {7, 4, 1, 1, 2, 2, 5, 5};
unsigned int index = 0;
unsigned int v_before = 0;
unsigned int threshold = 10; //???????check
unsigned char now = 0;
void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = (ADRESH << 2) | (ADRESL >> 6); //high-bits 8, low-bits 2 => 10bits
    
    if((value - v_before) > threshold || (v_before - value) > threshold){
        index = value / 128;
        v_before = value;
    } 
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
    TRISB = 0x00; //output
    LATB = 0x00; //clear PORTB
    
    //step1
    ADCON1bits.VCFG0 = 0;     //?????????
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input
    ADCON2bits.ADCS = 0b000;  //????000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 2 us acquisition time ? 2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 
    
    
    //step2
    PIE1bits.ADIE = 1; //??ADC??
    PIR1bits.ADIF = 0; //???????
    INTCONbits.PEIE = 1; //??????
    INTCONbits.GIE = 1; //??????


    //step3
    ADCON0bits.GO = 1; //??ADC?????????0
    LATB = A[now];
    
    while(1){
        if(now != index){
            now = index;
            LATB = A[now];
        }
    }
    
    return;
}
