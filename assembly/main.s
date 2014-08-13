@OGBAZI001 PRKYUM003

	.syntax unified
	.global _start
	.thumb
	.cpu cortex-m0
	
	.word 0x20001FFF
	.word _start + 1
	
_start: LDR R0, RAM_START
	LDR R1, First
	STR R1,[R0]
	LDR R1, Second
	STR R1,[R0,#0x4]
	LDR R1, Third
	STR R1,[R0,#0x8]
	LDR R1, Fourth
	STR R1,[R0,#0xC]

	@copy_to_RAM_complete:
	LDR 	R1, [R0]		
	LDR 	R2, [R0,#0x4]	
	LDR 	R3, [R0,#0x8]	
	SUBS 	R4,R1,R2
	STR 	R4,[R0,#0x10]	
	ADDS 	R5,R1,R2
	ADDS 	R5,R5,R3
	STR 	R5,[R0,#0x14]
	MOVS 	R5,R2
	EORS 	R2,R2,R3
	STR 	R2,[R0,#0x18]
	MULS 	R5,R3,R5
	STR 	R5,[R0,#0x1c]
	LDR 	R6,PERIFERAL
	STR 	R5,[R6]	

infinite_loop:
	B infinite_loop
	
	.align
RAM_START: 	.word 0x20000000
First:     	.word 0xAABBCCDD
Second:    	.word 0x00001122
Third:     	.word 0x00002233
Fourth:    	.word 0x55555555
PERIFERAL:	.word 0x40000000
