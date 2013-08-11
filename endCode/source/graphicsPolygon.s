.globl graphics_fillRect
graphics_PolygonContext:
	fbInfoAddr .req r0
	colour .req r1
	fbAddr .req r2
	x .req r3
	y .req r4
	w .req r5
	h .req r6
	
	ldr fbAddr,[fbInfoAddr,#32]
	
	maths .req r7
	
	ldr maths,=1024
	mul maths,y
	add maths,x
	lsl maths,#1
	add fbAddr,maths
	
	.unreq maths
	
	i .req r7
	mov i,#0
	
	loopi$:
		cmp i,h
		beq next$
		add i,#1
		a .req r8
		mov a,#0
		loopa$:
			cmp a,w
			beq endLoopa$
			add a,#1
			strh colour,[fbAddr]
			add fbAddr,#2
			b loopa$
		endLoopa$:
		maths .req r9
		ldr maths,=1024
		sub maths,h
		lsl maths,#1
		add fbAddr,maths
		.unreq maths
		b loopi$
		
	next$:
	.unreq fbInfoAddr
	.unreq colour
	.unreq fbAddr
	.unreq x
	.unreq y
	.unreq w
	.unreq h
	.unreq i
	.unreq a
	mov pc,lr
