///右旋到底開始
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
     TRISB = 0x00; //設為輸出端
    LATB = 0x00; //clear PORTD
    
    //step1
    ADCON1bits.VCFG0 = 0;       //參考電壓為內部電源
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 為analog input,其他則是 digital
    ADCON0bits.CHS = 0b0000;  //AN0 當作 analog input
    ADCON2bits.ADCS = 0b000;  //查表後設000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 2 us acquisition time設2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 
    
    
    //step2
    PIE1bits.ADIE = 1; //啟用ADC中斷
    PIR1bits.ADIF = 0; //清除中斷標誌位
    INTCONbits.PEIE = 1; //啟用周邊中斷
    INTCONbits.GIE = 1; //啟用全域中斷


    //step3
    ADCON0bits.GO = 1; //啟用ADC，當轉換完成會變成0
    LATB = A[now];
    
    while(1){
        if(now != index){
            now = index;
            LATB = A[now];
        }
    }
    
    return;
}
