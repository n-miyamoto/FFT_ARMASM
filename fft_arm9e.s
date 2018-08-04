	.arch armv7-a
	.eabi_attribute 28, 1
	.fpu vfpv3-d16
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"fft_arm9e.c"
	.text
	.align	2
	.global	fft_16_arm9e
	.syntax unified
	@.thumb
	@.thumb_func
y	.req	r0
c	.req	r0
x	.req	r1	
N	.req	r2
S	.req	r2
R	.req	r3
x0_r	.req	r4
x0_i	.req	r5
x1_r	.req	r6
x1_i	.req	r7
x2_r	.req	r8
x2_i	.req	r9
x3_r	.req	r10
x3_i	.req	r11
y3_r	.req	r11
y3_i	.req	r10
t0	.req	r12
t1	.req	r14

.macro	c_ldr0	a,	offset
	ldrsh	x0_i,	[\a, #2]
	ldrsh	x0_r,	[\a],	\offset
.endm
.macro	c_ldr1	a,	offset
	ldrsh	x1_i,	[\a, #2]
	ldrsh	x1_r,	[\a],	\offset
.endm
.macro	c_ldr2	a,	offset
	ldrsh	x2_i,	[\a, #2]
	ldrsh	x2_r,	[\a],	\offset
.endm
.macro	c_ldr3	a,	offset
	ldrsh	x3_i,	[\a, #2]
	ldrsh	x3_r,	[\a],	\offset
.endm

.macro 	c_fft4	s
	add	x2_r,	x2_r,	x3_r
	add	x2_i,	x2_i,	x3_i
	sub	x3_r,	x2_r,	x3_r,	LSR#1
	sub	x3_i,	x2_i,	x3_i,	LSR#1

	mov	x0_r,	x0_r,	x1_r,	ASR# (2+\s)		
.endm

	@void fft_16_arm9e(short *y, short *x, unsigned int N)
fft_16_arm9e:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	stmfd	sp!,	{r4-r11, lr}
	mov	t0,	#0
	mvn	R,	#0x80000000
	@first stage load and bit reverse
first_stage_arm9e:
	adds	t1,	x,	t0,	LSL#2
	c_ldr0	t1,	N
	c_ldr2	t1,	N
	c_ldr1	t1,	N
	c_ldr3	t1,	N
	c_fft4	0
	ldmfd	sp!,	{r4-r11, pc}


	.size	fft_16_arm9e, .-fft_16_arm9e
	.ident	"GCC: (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609"
	.section	.note.GNU-stack,"",%progbits
