.include "m16def.inc"


.def temp=r16
.def data=r17
.def delay=r18
.def counter=r19
.def counter2=r20
.def delay2=r21
.def inner_count_L=R24 
.def inner_count_H=R25
.def outer_count_L=R26 ; (XL)
.def outer_count_H=R27 ; (XH)


reset:
    ldi temp,LOW(RAMEND) ;arxikopoiisti stack pointer
    out SPL,temp
	ldi temp,HIGH(RAMEND)
	out SPH,temp
	ser temp
	out DDRB,temp ;DDRB ws thyra eksodou
	out PORTB,temp
	clr temp
	out DDRD,temp ;DDRD ws thyra eisodou
	ldi counter,0 ;counter=0

ch_sw:
	rcall inc_counter 
	in temp,PIND
	cpi temp, 0b11111110 ;if sw0=on
	breq DLY0
	cpi temp,0b11111101 ;if sw1=on
	breq DLY1
	cpi temp,0b11111011 ;if sw2=on
	breq DLY2
	cpi temp,0b11110111 ;if sw3=on
	breq DLY3
	rjmp ch_sw

inc_counter:
	rcall time_delay_05s
	inc counter
	ret
	
DLY0:
	in temp,PIND
	cpi temp,0b11111111 
	breq sw0 ;if the switch is released go to sw0
	rjmp DLY0

DLY1:
	in temp,PIND
	cpi temp,0b11111111 
	breq sw1 ;if the switch is released go to sw1
	rjmp DLY1

DLY2:
	in temp,PIND
	cpi temp,0b11111111 
	breq sw2 ;if the switch is released go to sw2
	rjmp DLY2

DLY3:
	in temp,PIND
	cpi temp,0b11111111 
	breq sw3 ;if the switch is released go to sw3
	rjmp DLY3
	
sw0:
	mov data,counter
	com data
	out PORTB, data	
	ldi counter2,0
	
loop_sw0:
	rcall inc_counter
	mov data,counter
	com data
	out PORTB, data	
	inc counter2
	cpi counter2,6 ;if time=3s
	
	breq led_off0
	rjmp loop_sw0

led_off0:
	ser temp	
	out PORTB, temp 
	rjmp ch_sw

sw1:
    mov data,counter
	com data
	out PORTB, data	
	rcall time_delay_3s
	rjmp reset

sw2:
    mov data,counter
	com data
	out PORTB, data	
	rcall time_delay_3s
	ser temp
	out PORTB,temp
	rjmp wait_sw7

wait_sw7:
	in temp,PIND
	cpi temp,0b01111111
	breq DLY7
	rjmp wait_sw7

DLY7:
	in temp,PIND
	cpi temp,0b11111111 
	breq ch_sw ;if the switch is released go to ch_sw
	rjmp DLY7

sw3:
	dec counter
	mov data,counter
	com data
	out PORTB, data	
	rcall time_delay_3s
	cpi counter,10
	breq led_on1s
	rjmp sw3

led_on1s:
	clr temp
	out PORTB, temp
	rcall inc_counter
	cpi counter,15
	breq exit
	rcall inc_counter
	rjmp led_off1s	


led_off1s:
	ser temp
	out PORTB, temp
    rcall inc_counter
	rcall inc_counter
	rjmp led_on1s

exit:
	ser temp 
	out PORTB,temp
	rjmp end

end:
	rjmp end



time_delay_05s:
	          ldi outer_count_L, $78	; 1 cycle
	          ldi outer_count_H, $02	; 1 cycle
              outer_loop2:
			  ldi inner_count_L, $78	; 1 cycle
	          ldi inner_count_H, $02	; 1 cycle
              inner_loop2:
	          nop				; 1 cycle, possible use of more "nop" instructions for longer delays
	          sbiw inner_count_L, 1	; 2 cycles
	          brne inner_loop2			; 2 cycles if true (Ni-1 times), 1 cycle if false
	          sbiw outer_count_L, 1		; 2 cycles
              brne outer_loop2 			; 2 cycles if true (No-1 times), 1 cycle if false
	          ret						; 4 cycles (plus 3 cycles for rcall)

time_delay_3s:
	          ldi outer_count_L, $0D	; 1 cycle
	          ldi outer_count_H, $06	; 1 cycle
              outer_loop:
			  ldi inner_count_L, $0D	; 1 cycle
	          ldi inner_count_H, $06	; 1 cycle
              inner_loop:
	          nop						; 1 cycle, possible use of more "nop" instructions for longer delays
	          sbiw inner_count_L, 1		; 2 cycles
	          brne inner_loop		; 2 cycles if true (Ni-1 times), 1 cycle if false
	          sbiw outer_count_L, 1	; 2 cycles
              brne outer_loop 		; 2 cycles if true (No-1 times), 1 cycle if false
	          ret		
