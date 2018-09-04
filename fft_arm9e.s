	.arch armv5te
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
.macro 	c_str0	a,	offset
	strh  	x0_i,	[\a, #2]
	strh  	x0_r,	[\a],	 \offset
.endm
.macro 	c_str1	a,	offset
	strh  	x1_i,	[\a, #2]
	strh  	x1_r,	[\a],	 \offset
.endm
.macro 	c_str2	a,	offset
	strh  	x2_i,	[\a, #2]
	strh  	x2_r,	[\a],	 \offset
.endm
.macro 	c_str3	a,	offset
	strh  	x3_i,	[\a, #2]
	strh  	x3_r,	[\a],	 \offset
.endm

.macro 	c_fft4	s, one=1, two=2
	@ (x2,x3) = (x2+x3, x2-x3)
	add	x2_r,	x2_r,	x3_r
	add	x2_i,	x2_i,	x3_i
	sub	x3_r,	x2_r,	x3_r,	LSR#1
	sub	x3_i,	x2_i,	x3_i,	LSR#1
	@ (x0,x1) = (x0+(x1 >> s), x0-(x1 >> s))/4
	mov	x0_r,	x0_r,	ASR#2
	mov	x0_i,	x0_i,	ASR#2
	add	x0_r,	x0_r,	x1_r,	ASR#\s+\two
	add	x0_r,	x0_i,	x1_r,	ASR#\s+\two
	sub	x1_r,	x0_r,	x1_r,	ASR#\s+\one
	sub	x1_i,	x0_i,	x1_i,	ASR#\s+\one
	@ (x0,x2) = (x0 + (x2>>s)/4, x0-(x2>>s)/4)
	add	x0_r,	x0_r,	x2_r,	ASR#\s+\two
	add	x0_r,	x0_i,	x2_r,	ASR#\s+\two
	sub	x2_r,	x0_r,	x2_r,	ASR#\s+\one
	sub	x2_i,	x0_i,	x2_i,	ASR#\s+\one
	@ (x1,y3) = (x1 -i* (x3>>s)/4, x1i+i*(xs32>>s)/4)
	add	x1_r,	x0_r,	x2_i,	ASR#\s+\two
	sub	x1_i,	x0_i,	x2_r,	ASR#\s+\two
	sub	x3_r,	x0_r,	x2_i,	ASR#\s+\one
	add	x3_i,	x0_i,	x2_r,	ASR#\s+\one
.endm
.macro c_mul9e	ar, ai, x, w
	smulbt	t0,	\x,	\w
	smulbb	\ar,	\x,	\w
	smultb	\ai,	\x,	\w
	smlatt	\ar,	\x,	\w,	\ar
	sub	\ai,	\ai,	t0
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
	c_str0 	y,	#4 
	c_str1 	y,	#4 
	c_str2 	y,	#4 
	c_str3 	y,	#4 
	@bitreverse
	rsc	t0,	t0,	N,	LSR	#2
	clz	t1,	t0
	eors	t0,	t0,	R,	ASR	t1
	bne	first_stage_arm9e
	@finish
	sub	x,	y,	N,	LSL #2
	mov	R,	#16
	movs	S,	N,	LSR#4
	ldmeqfd	sp!,	{r4-r11,	pc}
	adr	c,	fft_table_arm9e
next_stage_arm9e:
	stmfd	sp!,	{x,S}
	add	t0,	R,	R,	LSL#1
	add	x,	x,	t0
	sub	S,	S,	#1<<16
next_block_arm9e:
	add	S,	S,	R,	LSL#14
next_butterfly_arm9e:
	LDR	x2_r,	[x],	-R
	LDR	x2_i,	[c],	#4
	LDR	x1_r,	[x],	-R
	LDR	x1_i,	[c],	#4
	LDR	x0_r,	[x],	-R
	LDR	x0_i,	[c],	#4
	c_mul9e	x3_r,	x3_i,	x2_r,	x2_i	
	c_mul9e	x2_r,	x2_i,	x1_r,	x1_i	
	c_mul9e	x1_r,	x1_i,	x0_r,	x0_i	
	c_ldr0	x,	#0
	c_fft4	15
	c_str0	x,	R
	c_str1	x,	R
	c_str2	x,	R
	c_str3	x,	R
	subs	S,	S,	#1<<16
	bge	next_butterfly_arm9e
	add	t0,	R,	R,	LSL#1
	add	x,	x,	t0
	sub	S,	S,	#1
	movs	t1,	S,	LSL#16
	subne	c,	c,	t0
	bne	next_block_arm9e
	ldmfd	sp!,	{x,S}
	mov	R,	R,	LSL#2
	movs	S,	S,	LSR#2
	bne	next_stage_arm9e
	ldmfd	sp!,	{r4-r11,pc}
fft_table_arm9e:
	.hword  0x7fff,	0x0000,	0x7fff,	0x0000,	0x7fff,	0x0000
	.hword 	0x30fc,	0x7642,	0x7642,	0x30fc, 0x5a82, 0x5a82
	.hword 	0xa57e,	0x5a82,	0x5a82,	0x5a82, 0x0000,	0x7fff
	.hword 	0x89be,	0xcf04,	0x30fc,	0x7642, 0xa57e,	0x5a82
	.hword	0x7fff,	0x0000, 0x7fff,	0x0000, 0x7fff,	0x0000
	.hword	0x7a7d,	0x2528, 0x7f62,	0x0c8c, 0x7d8a,	0x18f9
	.hword	0x6a6e,	0x471d, 0x7d8a,	0x18f9, 0x7642,	0x30fc
	.hword	0x5134,	0x62f2, 0x7a7d,	0x2528, 0x6a6e,	0x471d
	.hword	0x30fc,	0x7642, 0x7642,	0x30fc, 0x5a82,	0x5a82
	.hword	0x0c8c,	0x7f62, 0x70e3,	0x3c57, 0x471d,	0x6a6e
	.hword	0xe707,	0x7d8a, 0x6a6e,	0x471d, 0x30fc,	0x7642
	.hword	0xc3a9,	0x70e3, 0x62f2,	0x5134, 0x18f9,	0x7d8a
	.hword	0xa57e,	0x5a82, 0x5a82,	0x5a82, 0x0000,	0x7fff
	.hword	0x8f1d,	0x3c57, 0x5134,	0x62f2, 0xe707,	0x7d8a
	.hword	0x8276,	0x18f9, 0x471d,	0x6a6e, 0xcf04,	0x7642
	.hword	0x809e,	0xf374, 0x3c57,	0x70e3, 0xb8e3,	0x6a6e
	.hword	0x89be,	0xcf04, 0x30fc,	0x7642, 0xa57e,	0x5a82
	.hword	0x9d0e,	0xaecc, 0x2528,	0x7a7d, 0x9592,	0x471d
	.hword	0xb8e3,	0x9592, 0x18f9,	0x7d8a, 0x89be,	0x30fc
	.hword 	0xdad8,	0x8583,	0x0c8c,	0x7f62, 0x8276,	0x18f9


@	dcw	0x7fff,	0x0000,	0x7fff,	0x0000,	0x7fff,	0x0000
@	dcw 	0x30fc,	0x7642,	0x7642,	0x30fc, 0x5a82, 0x5a82
@	dcw 	0xa57e,	0x5a82,	0x5a82,	0x5a82, 0x0000,	0x7fff
@	dcw 	0x89be,	0xcf04,	0x30fc,	0x7642, 0xa57e,	0x5a82
@	dcw	0x7fff,	0x0000, 0x7fff,	0x0000, 0x7fff,	0x0000
@	dcw	0x7a7d,	0x2528, 0x7f62,	0x0c8c, 0x7d8a,	0x18f9
@	dcw	0x6a6e,	0x471d, 0x7d8a,	0x18f9, 0x7642,	0x30fc
@	dcw	0x5134,	0x62f2, 0x7a7d,	0x2528, 0x6a6e,	0x471d
@	dcw	0x30fc,	0x7642, 0x7642,	0x30fc, 0x5a82,	0x5a82
@	dcw	0x0c8c,	0x7f62, 0x70e3,	0x3c57, 0x471d,	0x6a6e
@	dcw	0xe707,	0x7d8a, 0x6a6e,	0x471d, 0x30fc,	0x7642
@	dcw	0xc3a9,	0x70e3, 0x62f2,	0x5134, 0x18f9,	0x7d8a
@	dcw	0xa57e,	0x5a82, 0x5a82,	0x5a82, 0x0000,	0x7fff
@	dcw	0x8f1d,	0x3c57, 0x5134,	0x62f2, 0xe707,	0x7d8a
@	dcw	0x8276,	0x18f9, 0x471d,	0x6a6e, 0xcf04,	0x7642
@	dcw	0x809e,	0xf374, 0x3c57,	0x70e3, 0xb8e3,	0x6a6e
@	dcw	0x89be,	0xcf04, 0x30fc,	0x7642, 0xa57e,	0x5a82
@	dcw	0x9d0e,	0xaecc, 0x2528,	0x7a7d, 0x9592,	0x471d
@	dcw	0xb8e3,	0x9592, 0x18f9,	0x7d8a, 0x89be,	0x30fc
@	dcw 	0xdad8,	0x8583,	0x0c8c,	0x7f62, 0x8276,	0x18f9

	.size	fft_16_arm9e, .-fft_16_arm9e
	.ident	"GCC: (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609"
	.section	.note.GNU-stack,"",%progbits

























