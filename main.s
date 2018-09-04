	.arch armv5te
	.eabi_attribute 28, 1
	.fpu vfpv3-d16
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"main.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"%d + %d i \012\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 136
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #136
	ldr	r3, .L6
	ldr	r3, [r3]
	str	r3, [fp, #-8]
	sub	r3, fp, #136
	mov	r2, #64
	mov	r1, #0
	mov	r0, r3
	bl	memset
	sub	r3, fp, #72
	mov	r2, #64
	mov	r1, #0
	mov	r0, r3
	bl	memset
	sub	r1, fp, #72
	sub	r3, fp, #136
	mov	r2, #16
	mov	r0, r3
	bl	fft_16_arm9e
	mov	r3, #0
	str	r3, [fp, #-140]
	b	.L2
.L3:
	ldr	r3, [fp, #-140]
	lsl	r3, r3, #1
	lsl	r3, r3, #1
	sub	r2, fp, #4
	add	r3, r2, r3
	sub	r3, r3, #68
	ldrsh	r3, [r3]
	mov	r1, r3
	ldr	r3, [fp, #-140]
	lsl	r3, r3, #1
	add	r3, r3, #1
	lsl	r3, r3, #1
	sub	r2, fp, #4
	add	r3, r2, r3
	sub	r3, r3, #68
	ldrsh	r3, [r3]
	mov	r2, r3
	ldr	r0, .L6+4
	bl	printf
	ldr	r3, [fp, #-140]
	add	r3, r3, #1
	str	r3, [fp, #-140]
.L2:
	ldr	r3, [fp, #-140]
	cmp	r3, #15
	ble	.L3
	mov	r3, #0
	mov	r0, r3
	ldr	r3, .L6
	ldr	r2, [fp, #-8]
	ldr	r3, [r3]
	cmp	r2, r3
	beq	.L5
	bl	__stack_chk_fail
.L5:
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L7:
	.align	2
.L6:
	.word	__stack_chk_guard
	.word	.LC0
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609"
	.section	.note.GNU-stack,"",%progbits
