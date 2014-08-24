@OGBAZI001 PRKYUM003
    .syntax unified
    .global _start
    .cpu cortex-m0
    .thumb
vectors:
    .word 0x20001FFF
    .word _start + 1
	
	
_start:
    LDR R0, =0x40021000                 
    LDR R1, [R0, #0x14]                 
    LDR R2, =0b1100000000000000000     
    ORRS R1, R1, R2                     
    STR R1, [R0, #0x14]
	
	LDR R0, =0x48000400                 
    LDR R1, [R0]                        
    LDR R2, =0b0101010101010101         
    ORRS R1, R1, R2                     
    STR R1, [R0]                  
	
	LDR R3, =0x48000000                 
	LDR R2,=0x5				@Set up pull up resistors
	STR R2,[R3,0x0C]
	
	
	
	@LDR R7, first
	LDR R5, =start_of_data  @source
	LDR R4, =0x20000000		@destination
	LDR R6, =end_of_data	@address of last data limit
	SUBS R6,R6,R5			@Get the size of the data to be copied to RAM
	ADDS R6,R6,R4			@get address of last word to put in RAM
copy_to_RAM:
	LDR R7,[R5]
	STR R7,[R4]
	ADDS R5,#4
	ADDS R4,#4
	CMP R4,R6
	BNE copy_to_RAM
	LDR R4,=0x20000000	@reset R4 to first byte in RAM	before moving to copy_to_RAM_complete

copy_to_RAM_complete:
	LDRB R5,[R4]
	ADDS R5,#1
	STRB R5,[R4]
	ADDS R4,#1
	CMP R4,R6
	BNE copy_to_RAM_complete
	LDR R4,=0x20000000 @Reset R4 to first byte in RAM	before moving to copy_to_RAM_complete
	LDRB R1,[R4] @To store the maximum unsigned byte

increment_of_bytes_complete:

find_max_unsigned:
	LDRB R5,[R4]
	CMP R5,R1
	BHI set_max_unsinged
	ADDS R4,#1
	CMP R4,R6
	BNE find_max_unsigned
	
	LDR R4,=0x20000000 @Reset R4 to RAM start
	LDRB R2,[R4] @to stores the minimum unsigned byte
	B find_min_unsigned
	
set_max_unsinged:
	MOVS R1,R5
	STRB R5,[R6,#1]
	B find_max_unsigned

find_min_unsigned:
	LDRB R5,[R4]
	CMP R5,R2
	BLO set_min_unsinged
	ADDS R4,#1
	CMP R4,R6
	BNE find_min_unsigned
	
	LDR R4,=0x20000000 @ram start
	LDRB R7,[R4] @to stores the maximum signed byte
	B find_max_signed
	
set_min_unsinged:
	MOVS R2,R5
	STRB R5,[R6,#2]
	B find_min_unsigned	
	
find_max_signed:
	LDRB R5,[R4]
	CMP R7,R5
	BGT set_signed_max
	ADDS R4,#1
	CMP R4,R6
	BNE find_max_signed
	
	B ButtonS0
	
set_signed_max:
	MOVS R7,R5
	STRB R5,[R6,#3]
	B find_max_signed
	
ButtonS0:
	LDR R5,[R3,0x10]
	MOVS R6,1			@Check if S0 is pressed
	ANDS R5,R5,R6
	@CMP R1,1
	BEQ display_MIN_unsigned
	
ButtonS1:
	LDR R5,[R3,0x10]		@Load input data register's content
	MOVS R6,0b10			@Check if S1 is pressed
	ANDS R5,R6,R5
	BEQ display_MAX_signed
	
display_MAX_unsigned:
								@LDRB R2,[R6,#1]                         
    STR R1, [R0, #0x14]                 
	B ButtonS0

display_MIN_unsigned:
							@LDRB R2,[R6,#2]                         
    STR R2, [R0, #0x14]                 
	B ButtonS0
	
display_MAX_signed:
								@LDRB R2,[R6,#3]                         
    STR R7, [R0, #0x14]                 
	B ButtonS0
	
        .align  @ all data accesses on the Cortex-M0 must be aligned data accesses. 
start_of_data:
        .word 0x22f65244
        .word 0x4e66eca3
        .word 0x25c1c308
        .word 0xe278d1ca
        .word 0x10e865fe
        .word 0x839b17fb
        .word 0xde6ac773
        .word 0x49a0392b
        .word 0x442b580
        .word 0xae6e269d
        .word 0xcb220366
        .word 0x603debbe
        .word 0xfd88b1bf
        .word 0x49c5652f
        .word 0x25476c5a
        .word 0xa5c40771
        .word 0xb04d908d
        .word 0x831c1806
        .word 0x5b4f75d4
        .word 0x6b016b93
        .word 0x90dcb11a
        .word 0xefb6e394
        .word 0x44db27da
        .word 0xcf205f79
        .word 0xb1192a24
        .word 0x79cf44e2
        .word 0x371ce3ba
        .word 0x7a279ff5
        .word 0x6047dc
        .word 0xfa165142
        .word 0x12690fdc
        .word 0x5aad829e
        .word 0x19244ba0
        .word 0xb5174a3
        .word 0xbd7172c8
        .word 0x1d3b229f
        .word 0xada0357e
        .word 0x1d44e4e6
        .word 0x37caa86e
        .word 0x6a08fc5d
        .word 0x465faee1
        .word 0x2e52e372
        .word 0xd6016409
        .word 0x52012177
        .word 0x848249e0
        .word 0xcee8ec8d
        .word 0xca09fbe7
        .word 0x45ec4e32
        .word 0xa11ccfb5
        .word 0x95584228
end_of_data:    @ we label the NEXT address as the end pointer. This is data we do not want to copy. 
                @ Hence, the conditional loop should run while the source poiter is not pointing to end_of_data.		