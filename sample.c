List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x2B            ; 十六進制
    MOVLW D'15'           ; 十進制
    MOVLW b'00001111'     ; 二進制
    
    end                   ; 結束程式碼
