# main.s
# John Bretz
# CE 2801
# Lab 4
# Description: lcd api file

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

	# Commands for BSRR
	.equ E_SET,  0x400
	.equ RW_SET, 0x200
	.equ RS_SET, 0x100

.global lcd_init
.global lcd_clear
.global lcd_home
.global lcd_set_position
.global lcd_print_num
.global lcd_print_string
.global lcd_write_data


lcd_init:
	push {R1, LR}

    # Set up Ports
    bl setup_ports

    # Wait 40ms
    mov R1, #40
    bl delay_us

    # Write Function Set (0x38)
    mov R1, #0x38
    bl write_instruction

    mov R1, #37
    bl delay_us

    # Write Function Set (0x38)
    mov R1, #0x38
    bl write_instruction

    mov R1, #37
    bl delay_us

    # Write Display On/Off(0x0F)
    mov R1, #0x0F
    bl write_instruction

    mov R1, #37
    bl delay_us

    # Write Display Clear (0x01)
    bl lcd_clear

    # Write Entry Mode Set (0x06)
	mov R1, #0x06
	bl write_instruction

	mov R1, #37
    bl delay_us

	pop {R1, PC}

# Setups the ports for the LCD
setup_ports:
    push {R1-R3, LR}

    # Turn on Ports in RCC
	ldr R1, =RCC_BASE

	ldr R2, [R1, #RCC_AHB1ENR]
	orr R2, R2, #RCC_GPIOAEN   // enable gpioa
	orr R2, R2, #RCC_GPIOCEN   // enable gpioc
	str R2, [R1, #RCC_AHB1ENR]

    # Set DB Pins to Outputs
    ldr R1, =GPIOA_BASE
    ldr R2, [R1, #GPIO_MODER]

    ldr R3, =0x555500
    orr R2, R2, R3

    str R2, [R1, #GPIO_MODER]

    # Set RS RW E Pins to Outputs
    ldr R1, =GPIOC_BASE
    ldr R2, [R1, #GPIO_MODER]

    ldr R3, =0x150000
    orr R2, R2, R3

    str R2, [R1, #GPIO_MODER]

	pop {R1-R3, PC}

# Writes an instruction to the LCD
#
# R1 : input : instruction to write
write_instruction:
	push {R1-R5, LR}

	ldr R2, =GPIOA_BASE
	ldr R3, =GPIOC_BASE

	# Set RS=0,RW=0,E=1
	mov R4, #0
	bic R4, R4, #RS_SET
	bic R4, R4, #RW_SET
	orr R4, R4, #E_SET
	str R4, [R3, #GPIO_ODR]

	# Set R1 -> DataBus
	bfi R5, R1, #4, #8
	str R5, [R2, #GPIO_ODR]

	# Set E=0
	bic R4, R4, #E_SET
	str R4, [R3, #GPIO_ODR]

	pop {R1-R5, PC}


# Writes an ascii value to the current location of the LCD
#
# R1 : input : ascii byte to write
write_data:
	push {R1-R5, LR}

	ldr R2, =GPIOA_BASE
	ldr R3, =GPIOC_BASE

	# set RW=0, RS=1 E=1
	mov R4, #0
	bic R4, R4, #RW_SET
	orr R4, R4, #RS_SET
	orr R4, R4, #E_SET
	str R4, [R3, #GPIO_ODR]

	# write actual data
	ubfx R5, R1, #0, #8
	lsl R5, R5, #4
	str R5, [R2, #GPIO_ODR]

	# set E=0
	bic R4, R4, #E_SET
	str R4, [R3, #GPIO_ODR]

	mov R1, #37
	bl delay_us

	pop  {R1-R5, PC}


# Clears the screen
# includes delay
lcd_clear:
	push {R0-R1, LR}

	mov R1, #0x01
    bl write_instruction

    mov R1, #1520
    bl delay_us

	pop  {R0-R1, PC}

# Moves cursor to the home position
# includes delay
lcd_home:
	push {R1, LR}

	mov R1, #0x2
	bl write_instruction

	mov R1, #1520
	bl delay_us

	pop  {R1, PC}

# Moves cursor to a location
# includes delay
#
# R0 : input : row
# R1 : input : col
lcd_set_position:
	push {R1-R2, LR}

	bl lcd_home

	mov R2, R1
	cmp R0, #0
	beq no_change_line

	# second line starts at 41st digit.
	add R2, R2, #40

no_change_line:
	cmp R2, #0
	beq not_move_cursor

1:
	mov R1, #0x14
 	bl write_instruction

	mov R1,#37
	bl delay_us

	subs R2, R2, #1
	bne 1b

not_move_cursor:
	pop {R1-R2, PC}

# Prints a null terminated string to the display
# includes delay
#
# R1 : input  : address to the string
# R0 : output : number of characters written
lcd_print_string:
	push {R1-R3, LR}

	mov R0, #0 // counter
	mov R2, R1 // base address
	mov R3, #0 // offset

ld_next_byte:
	ldrb R1, [R2, R3]

	cmp R1, #0
	beq exit_print_string

	bl write_data
	add R3, R3, #1
	add R0, R0, #1
	b ld_next_byte

exit_print_string:
	pop  {R1-R3, PC}

# Prints a decimal number to the display
# can only print number between 0 and 9999
# includes delay
#
# R1 : input : the binary number to print
lcd_print_num:
	push {R1-R2, LR}
	movw R2, #9999
	cmp R1, R2

	bgt error

	# number is valid
	bl num_to_ascii
	ubfx R1, R0, #24, #8
	bl write_data

	ubfx R1, R0, #16, #8
	bl write_data

	ubfx R1, R0, #8, #8
	bl write_data

	ubfx R1, R0, #0, #8
	bl write_data

	pop {R1-R2, PC}

# R1 : input : an ascii code byte
lcd_write_data:
	push {LR}

	bl write_data

	pop  {PC}

error:
	# Error
	mov R1, 'E'
	bl write_data

	mov R1, 'r'
	bl write_data

	mov R1, 'r'
	bl write_data

	pop {R1-R2, PC}
