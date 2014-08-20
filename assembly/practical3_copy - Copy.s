@OGBAZI001 PRKYUM003
    .syntax unified
    .global _start
    .cpu cortex-m0
    .thumb

vectors:
    .word 0x20002000
    .word _start + 1

_start:
    @ the following block enables the GPIOB by setting the 18th bit of the RCC_AHBENR
    LDR R0, =0x40021000                 @ R0 = RCC base address
    LDR R1, [R0, #0x14]                 @ R1 = RCC_AHBENR
    LDR R2, =0b1100000000000000000      @ 18th bit high
    ORRS R1, R1, R2                     @ Force 18th bit (IOBEN) high
    STR R1, [R0, #0x14]                 @ write back to RCC_AHBENR

    @ the following sets the GPIOB[0:7] to be outputs by writing a pattern of 01 to the GPIOB_MODER
    LDR R0, =0x48000400                 @ R0 = GPIOB base address
    LDR R1, [R0]                        @ R1 = GPIOB_MODER
    LDR R2, =0b0101010101010101         @ pattern to set first 8 pairs of bits to be 01 (output)
    ORRS R1, R1, R2                     @ force the bits high, leaving the other bits unchanged
    STR R1, [R0]                        @ write back to GPIOB_MODER
	
	@ the following sets the GPIOB[0:7] to be outputs by writing a pattern of 01 to the GPIOB_MODER
    LDR R3, =0x48000000                 @ R0 = GPIOA base address
    LDR R1, [R3]                        @ R1 = GPIOB_MODER
    MOVS R2,0x0         		@ pattern to set first 8 pairs of bits to be 01 (output)
    ORRS R2, R2, R1                     @ force the bits high, leaving the other bits unchanged
    STR R2, [R3]                        @ write back to GPIOB_MODER
	
	@ pull push buttons down
	@LDR R1,[R3,0xC]
	LDR R2,=0x5
	@ANDS R1,R2,R1
	STR R2,[R3,0x0C]
	
ButtonS0:
	LDR R1,[R3,0x10]
	MOVS R2,1
	ANDS R1,R2,R1
	CMP R1,1
	BNE display_FF
	
display_AA:
	@ R1 already contains the pattern on the LEDs - just OR it with 0xAA
    MOVS R2, #0xAA                      @ can use MOVS as we only need to load 1 byte
    @ORRS R1, R1, R2                     @ set lower byte to AA, leaving rest of R1 unchanged.
    STR R2, [R0, #0x14]                 @ write back to GPIOB_ODR
	LDR R6,=#1000000
	B delay1

display_FF:
    @ R1 already contains the pattern on the LEDs - just OR it with 0xAA
	MOVS R2, #0xFF                      @ can use MOVS as we only need to load 1 byte
    @ORRS R1, R1, R2                     @ set lower byte to AA, leaving rest of R1 unchanged.
    STR R2, [R0, #0x14]                 @ write back to GPIOB_ODR
	LDR R6,=#1000000

delay1:
	SUBS R6,R6,#1
	BNE delay1

ButtonS01:
	LDR R1,[R3,0x10]
	MOVS R2,1
	ANDS R1,R2,R1
	CMP R1,1
	BNE display_00


display_55:
    @ R1 already contains the pattern on the LEDs - just OR it with 0xAA
	MOVS R2, #0x55                      @ can use MOVS as we only need to load 1 byte
    @ORRS R1, R1, R2                     @ set lower byte to AA, leaving rest of R1 unchanged.
    STR R2, [R0, #0x14]                 @ write back to GPIOB_ODR
	LDR R6,=#1000000
	B delay2

display_00:
    @ R1 already contains the pattern on the LEDs - just OR it with 0xAA
	MOVS R2, #0x00                      @ can use MOVS as we only need to load 1 byte
    @ORRS R1, R1, R2                     @ set lower byte to AA, leaving rest of R1 unchanged.
    STR R2, [R0, #0x14]                 @ write back to GPIOB_ODR
	LDR R6,=#1000000
   
delay2:
	SUBS R6,R6,#1
	BNE delay2

end: B ButtonS0
