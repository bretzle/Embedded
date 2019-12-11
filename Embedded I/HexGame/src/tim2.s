# main.s
# John Bretz
# CE 2801
# Lab 7
# Description: main file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ TIM2_BASE, 0x40000000
	.equ TIMx_ARR_OFFSET, 0x2C
	.equ TIMx_CCR1_OFFSET, 0x34
	.equ TIMx_CCR2_OFFSET, 0x38
	.equ TIMx_CCMR1_OFFSET, 0x18
	.equ TIMx_CCER_OFFSET, 0x20
	.equ TIMx_CR1_OFFSET, 0x00
	.equ TIMx_CR2_OFFSET, 0x10
	.equ TIMx_CNT_OFFSET, 0x24
	.equ TIMx_PSC_OFFSET, 0x28
	.equ TIMx_DIER_OFFSET, 0x0C
	.equ TIMx_SR_OFFSET, 0x10

	.equ NVIC_BASE, 0xE000E000
	.equ ISER0_OFFSET, 0x100

	.equ RCC_BASE, 0x40023800
	.equ APB1ENR_OFFSET, 0x40

.global tim2_init
.global start_tim2
.global stop_tim2

# Initializes the TIM2 (Enable the clock, set ARR, enable interrupt, and starts the clock).
tim2_init:
	push {R0,R4-R5,LR}

	# enable the clock for the timer.
	ldr R4, =RCC_BASE
	ldr R0, [R4, APB1ENR_OFFSET]
	orr R0, R0, #1 // Enable TIM2 clock.
	str R0, [R4, APB1ENR_OFFSET]

	ldr R4, =TIM2_BASE
	ldr R5, =NVIC_BASE

	# set the value in ARR to 1 ms.
	ldr R0, =(16000-1)
	str R0, [R4, TIMx_ARR_OFFSET]

	// Enable the update interrupt.
	mov R0, #1
	str R0, [R4, TIMx_DIER_OFFSET]

	// Enable the TIM2 global interrupt in NVIC controller.
	ldr R0, [R5, ISER0_OFFSET]
	orr R0, R0, #(1<<28)
	str R0, [R5, ISER0_OFFSET]

	// starts the timer.
	ldr R0, [R4, TIMx_CR1_OFFSET]
	orr R0, R0, #1
	str R0, [R4, TIMx_CR1_OFFSET]

	pop {R0, R4-R5, PC}


# Start the timer 2 and enable interrupt
start_tim2:
	push {R1, R3, LR}

	ldr R1, =TIM2_BASE

	// starts the timer.
	ldr R3, [R1, TIMx_CR1_OFFSET]
	orr R3, R3, #1
	str R3, [R1, TIMx_CR1_OFFSET]

	// enable the interrupt.
	ldr R3, [R1, TIMx_DIER_OFFSET]
	orr R3, R3, #1
	str R3, [R1, TIMx_DIER_OFFSET]

	pop {R1, R3, PC}


# Stop the timer 2 and reset value and disable interrupt
stop_tim2:
	push {R1, R3, LR}

	ldr R1, =TIM2_BASE

	// pause the timer.
	ldr R3, [R1, TIMx_CR1_OFFSET]
	bic R3, R3, #1
	str R3, [R1, TIMx_CR1_OFFSET]

	// disable the interrupt.
	ldr R3, [R1, TIMx_DIER_OFFSET]
	bic R3, R3, #1
	str R3, [R1, TIMx_DIER_OFFSET]

	// reset the count number back to 0.
	mov R3, #0
	str R3, [R1, TIMx_CNT_OFFSET]

	pop {R1, R3, PC}


.global TIM2_Interrupt_Handler
.thumb_func
TIM2_Interrupt_Handler:
	// clear the interupt flag.
	ldr R0, =TIM2_BASE
	ldr R1, [R0, TIMx_SR_OFFSET]
	bic R1, R1, #1
	str R1, [R0, TIMx_SR_OFFSET]

	// do something
	ldr R0, =num_ms
	ldr R1, [R0]
	add R1, R1, #1
	str R1, [R0]

	bx LR
