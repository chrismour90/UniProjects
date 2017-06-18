

.include "m16def.inc"

.def reg=r0
.def temp=r16
.def data=r17
.def delay=r18
.def counter=r19
.def counter2=r20
.def tempage1=r21
.def delay2=r22
.def inner_count_L=R24 
.def inner_count_H=R25
.def outer_count_L=R26 ; (XL)
.def outer_count_H=R27 ; (XH)


table: .db $75,$67,$05,$07,$19,$90, $75,$71,$01,$07,$19,$90, 0x61,0x64,0x72,0x6F,0x7A,0x69,0x73,0x67,0x69,0x61,0x6F,0x6F,0x69,0x73
	   .db 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	   .db 0x63,0x68,0x72,0x69,0x73,0x7A,0x6F,0x73,0x6D,0x6F,0x75,0x72,0x6F,0x75,0x7A,0x69
	   .db 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0



reset:
    ldi temp,LOW(RAMEND)
    out SPL,temp
	ldi temp,HIGH(RAMEND)
	out SPH,temp
	ser temp
	out DDRB,temp
	out PORTB,temp
	clr temp
	out DDRD,temp
	
chk_sw:
	in temp,PIND
	cpi temp, 0b11111110
	breq DLY
	cpi temp,0b11111101
	breq DLY
	cpi temp,0b11111011
	breq DLY
	cpi temp,0b11110111
	breq DLY
	rjmp chk_sw
	
DLY:
	dec delay
	brne DLY
	dec delay2
	brne DLY
	rjmp start

start:
	ldi ZH,HIGH(table)
	ldi ZL,LOW(table)
	lsl ZH;
	rol ZL;
	mov r23, zl
	ldi counter,0
    

	
main: 
    
	lpm data,z+
	com data
	out PORTB, data
	rcall TIME_DELAY_3s
	ser temp
    out PORTB, temp
	rcall TIME_DELAY_2s
	inc counter
	cpi counter, 12
	breq check_sw5	
	rjmp wait_sw
	
	  
	continue: 	
	rjmp main

check_sw5:

	in temp,PIND
	cpi temp, 0b11011111
	breq DLY3
	rjmp check_sw5

DLY3:
	dec delay
	brne DLY3
	dec delay2
	brne DLY3
	rjmp check_age

check_age:
    mov zl,r23
    adiw zl, 5
	lpm
	mov tempage1,reg
	adiw zl,6
	lpm
	cpse tempage1,reg
	brsh Light1
	brlo Light0


check_month:
    mov zl,r23
    adiw zl, 3
	lpm
	mov tempage1,reg
	adiw zl, 6
	lpm
	cpse tempage1,reg
	brsh Light1
	brlo Light0

    
check_day:
    mov zl,r23
    adiw zl, 2
	lpm
	mov tempage1,reg
	adiw zl,6
	lpm
	cp tempage1,reg
	brsh Light1
	brlo Light0

Light0:
	ldi temp,0b11111110
	out PORTB,temp
	rjmp end

Light1:
	ldi temp,0b11111101
	out PORTB,temp
	rjmp end



	
end:

	in temp,PIND
	cpi temp, 0b10111111
	breq DLY4
	rjmp end

DLY4:
    clr temp
	out PORTB, temp
	dec delay
	brne DLY4
	dec delay2
	brne DLY4
	rjmp reset



TIME_DELAY_3s:
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

TIME_DELAY_2s:
	          ldi outer_count_L, $F1	; 1 cycle
	          ldi outer_count_H, $04	; 1 cycle
              outer_loop2:
			  ldi inner_count_L, $F1	; 1 cycle
	          ldi inner_count_H, $04	; 1 cycle
              inner_loop2:
	          nop				; 1 cycle, possible use of more "nop" instructions for longer delays
	          sbiw inner_count_L, 1	; 2 cycles
	          brne inner_loop2			; 2 cycles if true (Ni-1 times), 1 cycle if false
	          sbiw outer_count_L, 1		; 2 cycles
              brne outer_loop2 			; 2 cycles if true (No-1 times), 1 cycle if false
	          ret						; 4 cycles (plus 3 cycles for rcall)
	
TIME_DELAY_1s:
	          ldi outer_count_L, $FE	; 1 cycle
	          ldi outer_count_H, $03	; 1 cycle
              outer_loop3:
			  ldi inner_count_L, $FE	; 1 cycle
	          ldi inner_count_H, $03	; 1 cycle
              inner_loop3:		
	          nop						; 1 cycle, possible use of more "nop" instructions for longer delays
	          sbiw inner_count_L, 1		; 2 cycles
	          brne inner_loop3			; 2 cycles if true (Ni-1 times), 1 cycle if false
	          sbiw outer_count_L, 1		; 2 cycles
              brne outer_loop3 			; 2 cycles if true (No-1 times), 1 cycle if false
	          ret						; 4 cycles (c   s 3 cycl
wait_sw:
	clr temp
    out PORTB, temp
	rcall time_delay_1s
	ser temp
    out PORTB, temp
	rcall time_delay_1s
	in temp,PIND
	cpi temp, 0b11111110
	breq DLY2
	cpi temp,0b11111101
	breq DLY2
	cpi temp,0b11111011
	breq DLY2
	cpi temp,0b11110111
	breq DLY2
	rjmp wait_sw
	
DLY2:
	dec delay
	brne DLY2
	dec delay2
	brne DLY2
	rjmp continue


exit:

