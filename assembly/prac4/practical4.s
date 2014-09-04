@OGBAZI001 PRKYUM003
    .syntax unified
    .global _start
    .cpu cortex-m0
    .thumb
	
vectors:
    .word 0x20001FFF
    .word _start + 1
	
	
_start:

	LDR R0, =0x82000000
	LDR R1, =0x7D000000
	ANDS R0,R1,R0
	LDR R0, =0x1FFFFFFF
	LDR R1, =0xE0000001
	ADDS R1,R0,R1
	
	LDR R0,=0x82000000
	LDR R1, =0x82000000
	SUBS R0,R1,R0
	
	LDR R0,=0
	LDR R1,=1
	CMP R0,R1
	
end: B end