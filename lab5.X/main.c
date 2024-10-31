/* 
 * File:   main.c
 * Author: user
 *
 * Created on 2024?10?22?, ?? 1:31
 */

#include <xc.h>
extern unsigned char mysqrt(unsigned char a);
extern unsigned int gcd(unsigned int a, unsigned int b);
extern unsigned int multi_signed(unsigned char a, unsigned char b);
/*
 * 
 */
void main(void) {
    volatile unsigned char result_basic = mysqrt(255);
    //volatile unsigned int result_advanced = gcd(33333, 22222);
    //volatile unsigned int result_bonus = multi_signed(100, 0);
    while(1);
    return;
}

