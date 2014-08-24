@OGBAZI001 PRKYUM003
    .syntax unified
    .global _start
    .cpu cortex-m0
    .thumb
vectors:
    .word 0x20002000
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
	LDR R2,=0x5
	STR R2,[R3,0x0C]
	
	LDR R7, first
	LDR R5, =first  ;destination
	LDR R4, =0x20000000
	LDR R6, =0x20000010

Loading:
	STR R7,[R4]
	ADDS R7,#4
	ADDS R4,#4
	CMP R4,R6
	BNE Loading
	
	
	
	
	
	
/*
ButtonS0a:
	LDR R1,[R3,0x10]
	MOVS R2,1
	ANDS R1,R2,R1
	CMP R1,1
	BNE display_FF
display_AA:
    MOVS R2, #0xAA                         
    STR R2, [R0, #0x14]                 
	LDR R6,=#1000000
	B ButtonS1a
display_FF:
	MOVS R2, #0xFF                      
    ORRS R1, R1, R2                     
    STR R2, [R0, #0x14]                 
	LDR R6,=#1000000
ButtonS1a:
	LDR R1,[R3,0x10]
	MOVS R2,0b10
	ANDS R1,R2,R1
	CMP R1,0b10
	BNE NewR6
	BEQ delay1
	
NewR6: LDR R6,=#500000	@500000
delay1:
	SUBS R6,R6,#1
	BNE delay1
ButtonS0b:
	LDR R1,[R3,0x10]
	MOVS R2,1
	ANDS R1,R2,R1
	CMP R1,1
	BNE display_00
display_55:
	MOVS R2, #0x55                     
    STR R2, [R0, #0x14]                
	LDR R6,=#1000000			@#1000000
	B ButtonS1b
display_00:
	MOVS R2, #0x00                      
    STR R2, [R0, #0x14]                 
	LDR R6,=#1000000			@#1000000
ButtonS1b:
	LDR R1,[R3,0x10]
	MOVS R2,0b10
	ANDS R1,R2,R1
	CMP R1,0b10
	BNE NewR62
	BEQ delay2	
NewR62: LDR R6,=#500000	@500000
delay2:
	SUBS R6,R6,#1
	BNE delay2
end: 
	B ButtonS0a
*/
	
first:		.word 0xAABBCCDD
			.word 0xAABBCCCC
			.word 0xAABBCCBB
			.word 0xAABBCCAA
			.word 0xAABBCC00
			