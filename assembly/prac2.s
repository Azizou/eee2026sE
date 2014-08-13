@OGBAZI001 PRKYUM003
	
	.global _start
	.syntax unified
	.cpu cortex-m0
	.thumb
	.text 0x08000000
	
	.word 0x20001FFF
	.word _start + 1
	
_start: LDR R0,RCC_BASE
	@ enable peripheral
	LDR R2,[R0,#0x14] @Load value at rcc_ahb 
	LDR R3, RCC_EN_PA_PB @ enable port A and B
	ORRS R2,R3,R2 @or the two
	STR R2,[R0,#0x14]
	
	@ configure relevant pins to the output
	LDR R1,PORTB_BASE
	LDR R2, OUT_PINS @ pins 1 2 3 4 5 6 7 8 
	STR R2,[R1]      @ configure gpio mode
	
all_off:
	LDR R3,ALL_OFF
	STR R3,[R1,#0x14]	@ GPIOB_ODR address, write 0x00000000
	@ turn all LEDs off

display_AA:
		MOVS R2,#0xAA
		STR R2,[R1,#0x14]	
		@ display the pattern 0xAA
all_on:
		MOVS R2,0xFF
		STR R2,[R1,#0x18]
			@ turn all LEDs on
bonus:
			LDR R2,PORTA_BASE
			LDR R3,ALL_OFF	@ to set pins mode to input
			STR R3,[R2]		@GPIOA_MODER port A input mode
			LDR R4,[R2,0x10]  @GPIOA_IDR
			MOVS R3,#1
			ANDS R3,R3,R4
			CMP R3,#1
			BEQ new
			STR R3,[R2,0x14]
			@If push button SW0 is held down, change the 
			@ LED pattern to 0x55
			
new:	
		MOVS R2,0x55
		STR R2,[R1,#0x18]
end:
	B all_off @ infinite loop cycling through
	.align
PORTB_BASE:		.word 0x48000400
RCC_BASE :		.word 0x40021000
RCC_RESET:      .word 0x00000014
RCC_EN_PA_PB:	.word 0x00060000
OUT_PINS:		.word 0x00005555
ALL_OFF:		.word 0x00000000
PORTA_BASE:		.word 0x48000000
