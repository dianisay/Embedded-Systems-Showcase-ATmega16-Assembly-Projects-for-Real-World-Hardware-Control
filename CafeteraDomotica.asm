; Final Assembler Code for Cafetera Domótica Project

; Configuración inicial

.org 0x0000
rjmp RESET          ; Reset vector
.org 0x0004
rjmp INTERRUPT1     ; Interrupt vector 1
.org 0x0008
rjmp INTERRUPT2     ; Interrupt vector 2

.equ TEMP = R16      ; Temporary register
.equ FLAG = R17      ; Flag register
.equ COUNTER = R18   ; Counter register

; Serial Communication Configuration
ldi TEMP, 0x33       ; Set baud rate
out UBRR0L, TEMP
ldi TEMP, 0x06       ; Enable transmitter and receiver
out UCSR0B, TEMP
ldi TEMP, 0x03       ; 8-bit data format
out UCSR0C, TEMP

; Comunicación serial

RECEIVE:
in TEMP, UDR0        ; Read received data
cpi TEMP, 0x30       ; Compare with '0'
brcs INVALID         ; If invalid, skip
subi TEMP, 0x30      ; Convert ASCII to binary
sts DATA, TEMP       ; Store in data register
rjmp RECEIVE         ; Loop for next byte
INVALID:
rjmp RECEIVE         ; Handle invalid data

; ADC (Analog-to-Digital Conversion)

; ADC initialization
ldi TEMP, 0xC0       ; Enable ADC and set prescaler
out ADCSRA, TEMP
ldi TEMP, 0x40       ; Use internal reference voltage
out ADMUX, TEMP

; Read ADC value and adjust PWM
ADC_READ:
in TEMP, ADCH        ; Read high byte of ADC
cpi TEMP, 0x80       ; Compare with threshold
brcs LOW_VOLUME      ; If below threshold
ldi TEMP, 0xFF       ; Set maximum PWM
out OCR1A, TEMP
rjmp ADC_READ
LOW_VOLUME:
ldi TEMP, 0x40       ; Set minimum PWM
out OCR1A, TEMP
rjmp ADC_READ

; Interrupciones

; Coffee Brewing Completion Interrupt
INTERRUPT1:
cbi PORTB, 0         ; Turn off heater
sbi PORTD, 1         ; Activate alarm
reti

; Alarm Stop Interrupt
INTERRUPT2:
cbi PORTD, 1         ; Deactivate alarm
clr FLAG             ; Clear flag
reti
