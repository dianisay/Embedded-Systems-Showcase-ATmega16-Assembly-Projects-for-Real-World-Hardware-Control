.INCLUDE "m16def.inc"
.org 0
Rjmp main

main:
    // configuración de Pila
    LDI R16, HIGH(RAMEND)
    OUT SPH, R16
    LDI R16, LOW(RAMEND)
    OUT SPL, R16

    // Definir puerto de salida
    SER R16
    OUT DDRC, R16

fin:
    call LedP
    rjmp fin

LedI:
    LDI R16, 170
    OUT PORTC, R16
    RET

LedP:
    LDI R16, 85
    OUT PORTC, R16
    RET

Led3:
    SER R16
    OUT PORTC, R16
    CBI PORTC, 0
    CBI PORTC, 4
    CBI PORTC, 7
    RET

LedE:
    SER R16
    OUT PORTC, R16
    CBI PORTC, 0
    CBI PORTC, 1
    CBI PORTC, 6
    CBI PORTC, 7
    RET

LedM:
    CLR R16
    OUT PORTC, R16
    SBI PORTC, 2
    SBI PORTC, 3
    SBI PORTC, 4
    SBI PORTC, 5
    RET
