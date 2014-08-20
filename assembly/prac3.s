@GWNJAM001 GWNJAM001
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
    LDR R2, =0b1000000000000000000      @ 18th bit high
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
    LDR R4, [R3]                        @ R1 = GPIOB_MODER
    LDR R5, =0xFFFFFFF0         		@ pattern to set first 8 pairs of bits to be 01 (output)
    ANDS R4, R4, R5                     @ force the bits high, leaving the other bits unchanged
    STR R4, [R3]                        @ write back to GPIOB_MODER

all_off:
    @ read in the data from GPIOB_ODR, force the lower byte to 0 and write back
    LDR R1, [R0, #0x14]                 @ R1 = GPIOB_ODR (R0 still contains GPIOB base address from above)
    LDR R2, =0xFFFFFF00                 @ pattern which will leave upper 3 bytes unchanged while clearing lower byte
    ANDS R1, R1, R2                     @ clear lower byte of ODR
    STR R1, [R0, #0x14]                 @ write back to GPIOB_ODR
	LDR R4,[R3,#0x10]
	MOVS R5,#0x1
	ANDS R5,R5,R4
	CMP R5,#1
	BEQ all_off_long
	

display_AA:
	@ R1 already contains the pattern on the LEDs - just OR it with 0xAA
    MOVS R2, #0xAA                      @ can use MOVS as we only need to load 1 byte
    ORRS R1, R1, R2                     @ set lower byte to AA, leaving rest of R1 unchanged.
    STR R1, [R0, #0x14]                 @ write back to GPIOB_ODR
	LDR R6,=#1500000
	LDR R4,[R3,#0x10]
	MOVS R5,#0x1
	ANDS R5,R5,R4
	CMP R5,#1
	BNE all_off_long

loop1:
	LDR R4,[R3,#0x10]
	MOVS R5,#0x1
	ANDS R5,R5,R4
	CMP R5,#1
	BEQ  all_off_long
	SUBS R6,R6,#1
	@CMP R5,#1
	BNE loop1
   @ you wish!
all_off2:
    @ read in the data from GPIOB_ODR, force the lower byte to 0 and write back
    LDR R1, [R0, #0x14]                 @ R1 = GPIOB_ODR (R0 still contains GPIOB base address from above)
    LDR R2, =0xFFFFFF00                 @ pattern which will leave upper 3 bytes unchanged while clearing lower byte
    ANDS R1, R1, R2                     @ clear lower byte of ODR
    STR R1, [R0, #0x14]
	/*LDR R4,=#3000000/*
loop2:
	SUBS R4,R4,#1
	@CMP R5,#1
	BNE loop2
   @ you wish!
*/
display_55:
    @ R1 already contains the pattern on the LEDs - just OR it with 0xAA
    MOVS R2, #0x55                      @ can use MOVS as we only need to load 1 byte
    ORRS R1, R1, R2                     @ set lower byte to AA, leaving rest of R1 unchanged.
    STR R1, [R0, #0x14]                 @ write back to GPIOB_ODR
	LDR R6,=#1500000
	LDR R4,[R3,#0x10]
	MOVS R5,#0b01
	ANDS R5,R5,R4
	CMP R5,#1
	BEQ all_off_long

   
bonus:
	LDR R4,[R3,#0x10]
	MOVS R5,#0b01
	ANDS R5,R5,R4
	CMP R5,#1
	BEQ all_off_long
	SUBS R6,R6,#1
	@CMP R5,#1
	BNE bonus
   @ you wish!
   
all_on:
   @ again, R1 already contains the contents of the ODR. Now we just need to set the lower byte
   MOVS R2, #0xFF                       @ pattern to set lower byte
   ORRS R1, R1, R2                      @ set lower byte
   STR R1, [R0, #0x14]                  @ write back to GPIOB_ODR
end: B all_off

all_off_long:
    @ read in the data from GPIOB_ODR, force the lower byte to 0 and write back
    LDR R1, [R0, #0x14]                 @ R1 = GPIOB_ODR (R0 still contains GPIOB base address from above)
    LDR R2, =0xFFFFFF00                 @ pattern which will leave upper 3 bytes unchanged while clearing lower byte
    ANDS R1, R1, R2                     @ clear lower byte of ODR
    STR R1, [R0, #0x14]                 @ write back to GPIOB_ODR
	

display_AA_long:
	@ R1 already contains the pattern on the LEDs - just OR it with 0xAA
    MOVS R2, #0xAA                      @ can use MOVS as we only need to load 1 byte
    ORRS R1, R1, R2                     @ set lower byte to AA, leaving rest of R1 unchanged.
    STR R1, [R0, #0x14]                 @ write back to GPIOB_ODR
	LDR R6,=#500000
	LDR R4,[R3,#0x10]
	MOVS R5,#0x1
	ANDS R5,R5,R4
	CMP R5,#1
	BNE all_off

loop1_long:
	SUBS R6,R6,#1
	@CMP R5,#1
	BNE loop1_long
   @ you wish!
all_off2_long:
    @ read in the data from GPIOB_ODR, force the lower byte to 0 and write back
    LDR R1, [R0, #0x14]                 @ R1 = GPIOB_ODR (R0 still contains GPIOB base address from above)
    LDR R2, =0xFFFFFF00                 @ pattern which will leave upper 3 bytes unchanged while clearing lower byte
    ANDS R1, R1, R2                     @ clear lower byte of ODR
    STR R1, [R0, #0x14]					@ clear LEDs

display_55_long:
    @ R1 already contains the pattern on the LEDs - just OR it with 0xAA
    MOVS R2, #0x55                      @ can use MOVS as we only need to load 1 byte
    ORRS R1, R1, R2                     @ set lower byte to AA, leaving rest of R1 unchanged.
    STR R1, [R0, #0x14]                 @ write back to GPIOB_ODR
	LDR R6,=#500000
	LDR R4,[R3,#0x10]
	MOVS R5,#0b01
	ANDS R5,R5,R4
	CMP R5,#1
	BNE all_off
   
bonus_long:
	LDR R4,[R3,#0x10]
	MOVS R5,#0b01
	ANDS R5,R5,R4
	CMP R5,#1
	BNE all_off
	SUBS R6,R6,#1
	@CMP R5,#1
	BNE bonus_long
   @ you wish!
   
end_long: B all_off_long




