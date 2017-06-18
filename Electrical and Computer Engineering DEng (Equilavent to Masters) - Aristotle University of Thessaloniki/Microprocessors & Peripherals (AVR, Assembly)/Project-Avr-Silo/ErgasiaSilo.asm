.include "m16def.inc"
.org $0 

.def Temp = R16
.def o_l = R17
.def m_l = R18
.def i_l = R19


jmp reset


reset:

	ser Temp
	out DDRB, Temp ; output on LEDs (PORT B!!)

	clr Temp
	out DDRA, Temp ; input on PORTA (potentiometers)
	out DDRD, Temp ; also input on PORTD (switches)

	ldi Temp, high(ramend)
	out SPH, Temp
	ldi Temp, low(ramend)
	out SPL, Temp
	
	ser Temp 
	out PORTB, Temp ;Turn off leds
	clr Temp

main:

waitStart:

	in Temp, PIND
	cpi Temp, 0b11111110 ; wait for start button to become 1 (0 because AVR)
	brne waitStart
	
Start:

	ldi Temp, 0b11000000 ;Init ADC so it can reads PA0

	rcall ADC_Init

	in Temp, PINA
	out PORTB, Temp ;DEBUGGING: Display potentiometer values on LEDs

	sbis PINA, 0
	rjmp Start		;Check if A1 is 1, if so then central silo is full

	ldi Temp, 0b11000001 ;Init ADC so it can reads PA1
	rcall ADC_Init

	sbic PINA, 1
	rjmp Start		;Check if B1 is 0, if so then Silo1 is empty

	ldi Temp, 0b11000010 ;Init ADC so it can reads PA2
	rcall ADC_Init
	
	sbic PINA, 2
	rjmp Start		;Check if B3 is 0, if so then Silo2 is empty

	sbic PIND, 1
	rjmp Start		;Check if Y1 is at 5/2 (wait for sw1 press)

Move:
	ldi Temp, 0b01111111 ; LED7 is ON, conveyor belt is moving
	out PORTB, Temp
	rcall SevenSecondDelay
	ldi Temp, 0b01010101
	out PORTB, Temp
	rcall SevenSecondDelay
	rjmp Move


SevenSecondDelay:

	ldi o_l, 150  ; outer loop: 115 * 240 * 260
outer:
	ldi m_l, 0xDC ; middle loop 240 * 260 us
mid:	 
	ldi i_l, 0xFF ;inner loop 1020 cycles -> 260us
inner:
	nop
	dec i_l
	brne inner
	dec m_l
	brne mid
	dec o_l
	brne outer

	ret


ADC_Init:
	out ADMUX,Temp ;read from selected mux	
	ldi Temp, 0b11000111
	out ADCSRA, Temp ; start convercion
	sei
	ret
