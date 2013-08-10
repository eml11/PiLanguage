/******************************************************************************
*	_kMain.s
*	 by Alex Chadwick
*
*	A sample assembly code implementation of the screen01 operating system, that 
*	creates a frame buffer and continually renders to it.
*
*	_kMain.s contains the main operating system, and IVT code.
******************************************************************************/

/*
* .globl is a directive to our assembler, that tells it to export this symbol
* to the elf file. Convention dictates that the symbol _start is used for the 
* entry point, so this all has the net effect of setting the entry point here.
* Ultimately, this is useless as the elf itself is not used in the final 
* result, and so the entry point really doesn't matter, but it aids clarity,
* allows simulators to run the elf, and also stops us getting a linker warning
* about having no entry point. 
*/
.section .init
.globl _start
_start:

/*
* According to the design of the RaspberryPi, addresses 0x00 through 0x20 
* actually have a special meaning. This is the location of the interrupt 
* vector table. Thus, we shouldn't make the code for our operating systems in 
* this area, as we will need it in the future. In fact the first address we are
* really safe to use is 0x8000.
*/
b main

/*
* This command tells the assembler to put this code at 0x8000.
*/
.section .text

/*
* main is what we shall call our main operating system method. It never 
* returns, and takes no parameters.
* C++ Signature: void main()
*/
main:

/*
* Set the stack point to 0x8000.
*/
	mov sp,#0x8000

/* NEW
* Setup the screen.
*/
	mov r0,#1024
	mov r1,#768
	mov r2,#16
	bl InitialiseFrameBuffer

/* NEW
* Check for a failed frame buffer.
*/
	teq r0,#0
	bne noError$
		
	mov r0,#16
	mov r1,#1
	bl SetGpioFunction

	mov r0,#16
	mov r1,#0
	bl SetGpio

	error$:
		b error$

	noError$:

	fbInfoAddr .req r0
	colour .req r1
	fbAddr .req r2
	x .req r3
	y .req r4
	w .req r5
	h .req r6
	
	ldr fbAddr,[fbInfoAddr,#32]
	
	counter .req r7
	mov counter,#7
	
	outputNumber .req r8
	ldr outputNumber,=0b11111010
	
	
	
	render$:
		fillWhite$:
			ldr colour,=0xffff
			mov r9,#7
			sub r9,counter
			/*ldr r10,=21
			mul r9,r10*/
            mov x,#0
			mov y,#0
			mov w,#20
			mov h,#20
			bl graphics_fillRect
		
		movingOn$:
		
		/* buffer to keep graphic on the screen for long enough - do not remove */
		push {x}
		ldr x,=0xffff
		bufferLoop$:
		sub x,#1
		cmp x,#0
		bne bufferLoop$
		
		pop {x}
	
		b render$
		
	
	endProgram$:
		b endProgram$
	
	