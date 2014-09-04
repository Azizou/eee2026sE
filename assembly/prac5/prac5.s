@OGBAZI001 PRKYUM003
@ ======= MODIFY THE LINE ABOVE!!!! =======

    .syntax unified
    .global _start
    .cpu cortex-m0
    .thumb

vectors: 
    .word 0x20002000        @ defines the reset value of the stack pointer
    .word _start + 1        @ defines the reset vector, thereby specifying the first instruction.
	
	.word Default_Handler + 1
	.word HardFault_Handler + 1
	.word Default_Handler + 1
	.word Default_Handler + 1
HardFault_Handler:          @ critical! The PC must jump here in the event that a HardFault exception occurs.
                            @ display 0xAA on the LEDs so that we know a fault happened.
        MOVS R2,0xAA
		STR R2,[R0,0x14]
        B HardFault_Handler

@ All other exceptions *should* be pointed here in order to have some sort of defined behaviour in
@ the event that they occur. However, this isn't necessary as they probably won't occur.
Default_Handler:        
        NOP
        B Default_Handler

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
        @ initialise pins connected to LEDs
	MOVS	R4,#0x1
	MOVS R5,#0x1
	PUSH {R4,R5}
        @ initialise the first two Fibonacci numbers by pushing two 1's to the stack
	LDR R6,=0x48000414
	LDR R7,=0x20000000
	STR R6,[R7]
        @ you're welcome to move some data to 0x2000 0000 for testing purposes now.

initialisations_complete:       @ critical! The word at 0x2000 0000 will be overwritten by the automarker now.

        @ in a loop 45 times, calculate the next Fibonacci number and push it to the stack
		MOVS R6,#45
fib_loop:
	LDR R4,[SP]
	LDR R5,[SP,#0x4]
	ADDS R4,R5,R4
	PUSH {R4}
	SUBS R6,#1
	BNE fib_loop
	
	

fib_calc_complete:              @ critical! Here, the automarker will verify the contents of the stack
		
		LDR R7,=0x20000000
		LDR R6,[R7]
		LDR R4,[SP]
		STR R4,[R6]
        @ read in the data contained in the first word of RAM and store the highest Fibonacci number at this address.
        @ Remeber: there is a risk that the data there is invalid. In this event, the hardfault should be handled. 


cycle_patterns:
        @ display all of the following, with a 0.5 seconds interval inbetween:
        @ 0x00 ; 0x81 ; 0xC3 ; 0xE7 ; 0xFF ; 0x7E ; 0x3C ; 0x18
        @ the delay 
		
		LDR R4,=#1000000
		MOVS R2,0x00
		STR R2,[R0,0x14]
		BL delay_routine
		
		LDR R4,=#1000000
		MOVS R2,0x81
		STR R2,[R0,0x14]
		BL delay_routine
		
		LDR R4,=#1000000
		MOVS R2,0xC3
		STR R2,[R0,0x14]
		BL delay_routine
		
		LDR R4,=#1000000
		MOVS R2,0xE7
		STR R2,[R0,0x14]
		BL delay_routine
		
		LDR R4,=#1000000
		MOVS R2,0xFF
		STR R2,[R0,0x14]
		BL delay_routine
		
		LDR R4,=#1000000
		MOVS R2,0x7E
		STR R2,[R0,0x14]
		BL delay_routine
		
		LDR R4,=#1000000
		MOVS R2,0x3C
		STR R2,[R0,0x14]
		BL delay_routine
		
		LDR R4,=#1000000
		MOVS R2,0x18
		STR R2,[R0,0x14]
		BL delay_routine

        B cycle_patterns

delay_routine:
        @ do delay here, and then return in the correct way.
		SUBS R4,#1
		BNE delay_routine
		BX LR
		
bonus:
	LDR R5,[R3,0x0C]
	

