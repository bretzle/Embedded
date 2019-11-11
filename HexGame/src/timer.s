# timer.s
# John Bretz
# CE 2801
# Lab 5
# Description: controls timer 3 / speaker

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ GPIOB_BASE, 0x40020400

	.equ RCC_BASE, 0x40023800
	.equ AHB1ENR_OFFSET, 0x30
	.equ APB1ENR_OFFSET, 0x40
	.equ GPIOB_EN, 0b10
	.equ TIM3_EN, 0b10

	.equ AFRL_OFFSET, 0x20
	.equ MODER_OFFSET, 0x0

	.equ TIM3_BASE, 0x40000400
	.equ TIMx_ARR_OFFSET, 0x2C
	.equ TIMx_CCR1_OFFSET, 0x34
	.equ TIMx_CCR2_OFFSET, 0x38
	.equ TIMx_CCMR1_OFFSET, 0x18
	.equ TIMx_CCER_OFFSET, 0x20
	.equ TIMx_CR1_OFFSET, 0x00

.global timer3_init
.global set_timer3
.global enable_tim3
.global disable_tim3

timer3_init:
	push {R0-R1, LR}

	# init clock for GPIOB.
	ldr R0, =RCC_BASE
	ldr R1, [R0, AHB1ENR_OFFSET]
	orr R1, R1, GPIOB_EN
	str R1, [R0, AHB1ENR_OFFSET]

	# init clock for TIM3
	ldr R0, =RCC_BASE
	ldr R1, [R0, APB1ENR_OFFSET]
	orr R1, R1, TIM3_EN
	str R1, [R0, APB1ENR_OFFSET]

	# enable alternate function for PB4.
	ldr R0, =GPIOB_BASE
	# PB4 is between bit 19 and bit 16.
	ldr R1, [R0, AFRL_OFFSET]
	orr R1, R1, #(0b0010<<16)
	str R1, [R0, AFRL_OFFSET]

	# set GPIOB into alternate function mode.
	ldr R0, =GPIOB_BASE
	ldr R1, [R0, MODER_OFFSET]
	# PB4 is between bit 9 and bit 8.
	bic R1, R1, #(0b11<<8)
	orr R1, R1, #(0b10<<8)
	str R1, [R0, MODER_OFFSET]

	pop  {R0-R1, PC}

set_timer3:
	push {R0-R1, LR}

	ldr R0, =TIM3_BASE

	# 8000 ticks for 500us high.
	# set the auto reload value and the
	# compare value of TIM3.

	# set the reset count.
	str R1, [R0, TIMx_ARR_OFFSET]

	# set the position of the toggle.
	mov R1, #0
	str R1, [R0, TIMx_CCR1_OFFSET]

	# select output mode - toggle.
	movw R1, #(0b011 << 4)
	str R1, [R0, TIMx_CCMR1_OFFSET]

	# compare output enable
	movw R1,#1
	str R1, [R0, TIMx_CCER_OFFSET]

	pop {R0-R1, PC}

enable_tim3:
	push {R0-R1, LR}

	# enable counter.
	ldr R0, =TIM3_BASE
	ldr R1, [R0, TIMx_CR1_OFFSET]
	mov R1, #1
	str R1, [R0, TIMx_CR1_OFFSET]

	pop {R0-R1, PC}

disable_tim3:
	push {R0-R1, LR}

	# stop making sound.
	ldr R0, =TIM3_BASE
	ldr R1, [R0, TIMx_CR1_OFFSET]
	mov R1, #0
	str R1, [R0, TIMx_CR1_OFFSET]

	pop {R0-R1, PC}
