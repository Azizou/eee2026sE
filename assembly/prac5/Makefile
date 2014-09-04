	
run:
	arm-none-eabi-as -g -a=test.lst -o test.o prac5.s
	arm-none-eabi-ld -Ttext=0x08000000 -o main.elf test.o
	arm-none-eabi-gdb main.elf
	
clean:
	rm -vf test.o main.elf test.lst