.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ APB2ENR_OFFSET, 0x44
	.equ AHB1ENR_OFFSET, 0x30
	.equ MODER_OFFSET, 0x0
	.equ RCC_BASE, 0x40023800

	.equ GPIOB_EN, 0x2
	.equ ADC1_EN, 1<<8

	.equ ADC1_BASE, 0x40012000
	.equ ADC_CR1_OFFSET, 0x04
	.equ ADC_CR2_OFFSET, 0x08
	.equ ADC_SQR3_OFFSET, 0x34
	.equ ADC_DR_OFFSET, 0x4C
	.equ ADC_SR_OFFSET, 0x00

	.equ NVIC_BASE, 0xE000E000
	.equ ISER0_OFFSET, 0x100

.global adc_init
.global start_convert

adc_init:
	push {R0-R2, LR}

	ldr R0, =RCC_BASE

	// enable gpio b
	ldr R1, [R0, #AHB1ENR_OFFSET]
	orr R1, R1, #GPIOB_EN
	str R1, [R0, #AHB1ENR_OFFSET]

	// RCC
	ldr R1, [R0, #APB2ENR_OFFSET]
	orr R1, R1, #ADC1_EN
	str R1, [R0, #APB2ENR_OFFSET]

	// turn on ADC
	ldr R0, =ADC1_BASE
	ldr R1, [R0, #ADC_CR2_OFFSET]
	orr R1, R1, #(1<<0)
	str R1, [R0, #ADC_CR2_OFFSET]

	// watch channel 8
	ldr R1, [R0, #ADC_SQR3_OFFSET]
	mov R2, #8
	bfi R1, R2, #0, #5
	str R1, [R0, #ADC_SQR3_OFFSET]

	// enable interrupt
	ldr r0,=NVIC_BASE
	ldr r1,[r0,ISER0_OFFSET]
	orr r1,r1,#(1<<18)
	str r1,[r0,ISER0_OFFSET]

	ldr r1,=ADC1_BASE
	ldr r2,[r1,ADC_CR1_OFFSET]
	orr r2,r2,#(1<<5) // Enable interrupt for EOC.
	str r2,[r1,ADC_CR1_OFFSET]

	pop {R0-R2, PC}

start_convert:
	push {R0-R1, LR}

	ldr R0, =ADC1_BASE
	ldr R1, [R0, #ADC_CR2_OFFSET]
	orr R1, R1, #(1<<30)
	str R1, [R0, #ADC_CR2_OFFSET]

	pop  {R0-R1, PC}


.global ADC_Convert_Handler
.thumb_func
ADC_Convert_Handler:
	mov R12, LR

	ldr R0, =ADC1_BASE
	ldr R1, [R0, #ADC_DR_OFFSET]
	bl convert_to_c
	bl convert_to_f
	bl lcd_home
	bl pretty_print

	mov LR, R12
	bx LR
