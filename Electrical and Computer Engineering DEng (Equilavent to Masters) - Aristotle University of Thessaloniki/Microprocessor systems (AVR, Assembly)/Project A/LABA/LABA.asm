

.include "m16def.inc"

.def reg=r0
.def temp=r16
.def data=r17
.def temp_zl=r18
.def counter=r19
.def counter2=r20
.def tempage1=r21
.def tempage2=r22
.def inner_count_L=R24 
.def inner_count_H=R25
.def outer_count_L=R26 ; (XL)
.def outer_count_H=R27 ; (XH)

.cseg
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
	brsh check_age	
	rjmp main

check_age:
    mov zl,r23
    adiw zl, 5
	lpm
	mov tempage1,reg
	adiw zl,6
	lpm
	mov tempage2,reg
	cpse tempage1,tempage2
	brsh Light1
	brlo Light0


check_month:
    mov zl,r23
    adiw zl, 3
	lpm
	mov tempage1,reg
	adiw zl, 6
	lpm
	mov tempage2,reg
	cpse tempage1,tempage2
	brsh Light1
	brlo Light0

    
check_day:
    mov zl,r23
    adiw zl, 2
	lpm
	mov tempage1,reg
	adiw zl,6
	lpm
	mov tempage2,reg
	cp tempage1,tempage2
	brsh Light1
	brlo Light0

Light0:
	ldi temp,0b11111110
	
	out PORTB,temp
	rcall TIME_DELAY_3s
	ser temp
    out PORTB, temp
	rcall TIME_DELAY_2s
	rjmp end

Light1:
	ldi temp,0b11111101
	
	out PORTB,temp
	rcall TIME_DELAY_3s
	ser temp
    out PORTB, temp
	rcall TIME_DELAY_2s
	rjmp end



	
end:
    rjmp end

	

TIME_DELAY_3s:
	          ldi outer_count_L, $0d	; 1 cycle
	          ldi outer_count_H, $06	; 1 cycle
              outer_loop:
			  ldi inner_count_L, $0d	; 1 cycle
	          ldi inner_count_H, $06	; 1 cycle
              inner_loop:
	          nop						; 1 cycle, possible use of more "nop" instructions for longer delays
	          sbiw inner_count_L, 1		; 2 cycles
	          brne inner_loop		; 2 cycles if true (Ni-1 times), 1 cycle if false
	          sbiw outer_count_L, 1	; 2 cycles
              brne outer_loop 		; 2 cycles if true (No-1 times), 1 cycle if false
	          ret		

TIME_DELAY_2s:
	          ldi outer_count_L, $f1	; 1 cycle
	          ldi outer_count_H, $04	; 1 cycle
              outer_loop2:
			  ldi inner_count_L, $f1	; 1 cycle
	          ldi inner_count_H, $04	; 1 cycle
              inner_loop2:
	          nop				; 1 cycle, possible use of more "nop" instructions for longer delays
	          sbiw inner_count_L, 1	; 2 cycles
	          brne inner_loop2		; 2 cycles if true (Ni-1 times), 1 cycle if false
	          sbiw outer_count_L, 1	; 2 cycles
              brne outer_loop2 		; 2 cycles if true (No-1 times), 1 cycle if false
	          ret				; 4 cycles (plus 3 cycles for rcall)




