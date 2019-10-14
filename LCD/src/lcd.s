@ main.s
@ John Bretz
@ CE 2801
@ Lab 4
@ Description: lcd api file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

	.equ RCC_BASE, 0x40023800
	.equ RCC_AHB1ENR, 0x30
	.equ RCC_GPIOAEN, 0x1
	.equ RCC_GPIOCEN, 0x4

	.equ GPIOA_BASE, 0x40020000
	.equ GPIOC_BASE, 0x40020800
	.equ GPIO_MODER, 0x0
	.equ GPIO_ODR, 0x14
	.equ BSRR_OFFSET, 0x18

	@ Commands for BSRR
	.equ E_SET,  0x400
	.equ RW_SET, 0x200
	.equ RS_SET, 0x100

.global LcdInit
.global lcd_clear
.global lcd_home
.global lcd_set_position
.global lcd_print_num
.global lcd_print_string


LcdInit:
	push {R1, LR}

    #Set up Ports
    bl setup_ports

    #Wait 40ms
    mov R1, #40
    bl delay_us

    #Write Function Set (0x38)
    mov R1, #0x38
    bl write_instruction

    mov R1, #37
    bl delay_us

    #Write Function Set (0x38)
    mov R1, #0x38
    bl write_instruction

    mov R1, #37
    bl delay_us

    #Write Display On/Off(0x0F)
    mov R1, #0x0F
    bl write_instruction

    mov R1, #37
    bl delay_us

    #Write Display Clear (0x01)
    bl lcd_clear

    #Write Entry Mode Set (0x06)
	mov R1, #0x06
	bl write_instruction

	mov R1, #37
    bl delay_us

	pop {R1, PC}

setup_ports:
    push {R1-R3, LR}
    #Turn on Ports in RCC
	ldr R1, =RCC_BASE

	ldr R2, [R1, #RCC_AHB1ENR]
	orr R2, R2, #RCC_GPIOAEN   @ enable gpioa
	orr R2, R2, #RCC_GPIOCEN   @ enable gpioc
	str R2, [R1, #RCC_AHB1ENR]

    #Set DB Pins to Outputs
    ldr R1, =GPIOA_BASE
    ldr R2, [R1, #GPIO_MODER]

    ldr R3, =0x555500
    orr R2, R2, R3

    str R2, [R1, #GPIO_MODER]

    #Set RS RW E Pins to Outputs
    ldr R1, =GPIOC_BASE
    ldr R2, [R1, #GPIO_MODER]

    ldr R3, =0x150000
    orr R2, R2, R3

    str R2, [R1, #GPIO_MODER]

	pop {R1-R3, PC}

#Writes instruction
#RS=0 RW=0  R1-Arg
#No returns
write_instruction:
	push {R1-R5, LR}

	ldr R2, =GPIOA_BASE
	ldr R3, =GPIOC_BASE

	#Set RS=0,RW=0,E=1
	mov R4, #0
	bic R4, R4, #RS_SET
	bic R4, R4, #RW_SET
	orr R4, R4, #E_SET
	str R4, [R3, #GPIO_ODR]

	#Set R1 -> DataBus
	bfi R5, R1, #4, #8
	str R5, [R2, #GPIO_ODR]

	#Set E=0
	bic R4, R4, #E_SET
	str R4, [R3, #GPIO_ODR]

	pop {R1-R5, PC}


#Writes data
#RS=1 RW=0  R1-Arg
#No returns
write_data:
	push {R1-R5, LR}

	ldr R2, =GPIOA_BASE
	ldr R3, =GPIOC_BASE

	mov R4, #0
	bic R4, R4, #RW_SET
	orr R4, R4, #RS_SET
	orr R4, R4, #E_SET
	str R4, [R3, #GPIO_ODR]

	@ write actual data
	ubfx R5, R1, #0, #8
	lsl R5, R5, #4
	str R5, [R2, #GPIO_ODR]

	bic R4, R4, #E_SET
	str R4, [R3, #GPIO_ODR]

	mov R1, #37
	bl delay_us

	pop  {R1-R5, PC}


@ Clears the screen
@ includes delay
lcd_clear:
	push {R0-R1, LR}

	mov R1, #0x01
    bl write_instruction

    mov R1, #1520
    bl delay_us

	pop  {R0-R1, PC}

@ Moves cursor to the home position
@ includes delay
lcd_home:
	push {LR}
	pop  {PC}

@ Moves cursor to a location
@ includes delay
@
@ R0 : input : row
@ R1 : input : col
lcd_set_postion:
	push {LR}
	pop  {PC}

@ Prints a null terminated string to the display
@ includes delay
@
@ R1 : input  : address to the string
@ R0 : output : number of characters written
lcd_print_string:
	push {R1, LR}
	pop  {R1, PC}

@ Prints a decimal number to the display
@ can only print number between 0 and 9999
@ includes delay
@
@ R1 : input : the binary number to print
lcd_print_num:
	push {R1-R2, LR}
	movw R2, #9999
	cmp R1, R2

	@ Error
	mov R1, 'E'
	bl write_data

	mov R1, 'r'
	bl write_data

	mov R1, 'r'
	bl write_data


	pop  {R1-R2, PC}

#Helper function you probably want to move somewhere else...
# about r1 mircoseonds
delay_us:
	push {R1, LR}

	lsl R1, R1, #3

1:
	subs R1, R1, #1
	bne 1b

	pop {R1, PC}
