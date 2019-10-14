@ main.s
@ John Bretz
@ CE 2801
@ Lab 4
@ Description: main file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

#Fill in addresses
	.equ RCC_BASE, 0x40023800
    .equ RCC_AHB1ENR, 0x30
    .equ RCC_GPIOAEN, 0x0
    .equ RCC_GPIOCEN, 0x3

    .equ GPIOA_BASE, 0x40020000
    .equ GPIOC_BASE, 0x40020800
    .equ GPIO_MODER, 0x0
    .equ GPIO_ODR, 0x14
    .equ GPIO_BSRR, 0x18

#What pin is each of these?
	.equ RS, 0x8
	.equ RW, 0x9
	.equ E,  0xA

#Commands for BSRR
	.equ RS_SET, 1<<RS
	.equ RS_CLR, 1<<(RS+16)
	.equ RW_SET, 1<<RW
	.equ RW_CLR, 1<<(RW+16)
	.equ E_SET, 1<<E
	.equ E_CLR, 1<<(E+16)

.global main
.global LcdInit

main:
	bl LcdInit
end:
	b end

LcdInit:
	push {LR}

    #Set up Ports
    bl setup_ports

    #Wait 40ms
    mov R1, #40
    bl delay_us

    #Write Function Set (0x38)
    mov R0, #0x38
    bl write_instruction

    #Write Function Set (0x38)
    mov R0, #0x38
    bl write_instruction

    #Write Display On/Off(0x0F)
    mov R0, #0x0F
    bl write_instruction

    #Write Display Clear (0x01)
    bl lcd_clear

    #Write Entry Mode Set (0x06)
	mov R0, #0x06
	bl write_instruction

	pop {PC}

#Local helper function
setup_ports:
    push {LR}
    #Turn on Ports in RCC
	ldr R1, =RCC_BASE

	ldr R2, [R1, #RCC_AHB1ENR]
	orr R2, R2, #RCC_GPIOAEN
	str R2, [R1, #RCC_AHB1ENR] @ enable gpioa

	ldr R3, [R1, #RCC_AHB1ENR]
	orr R3, R3, #RCC_GPIOAEN
	str R3, [R1, #RCC_AHB1ENR] @ enable gpioc

    #Set DB Pins to Outputs
    ldr R1, =GPIOA_BASE
    mov R4, #0xFF0
    orr R2, R2, R4
	str R2, [R1, #GPIO_MODER]

    #Set RS RW E Pins to Outputs
    ldr R1, =GPIOC_BASE
    mov R4, #0x700
    orr R3, R3, R4
    str R3, [R1, #GPIO_MODER]

	pop {PC}

#Writes instruction
#RS=0 RW=0  R0-Arg
#No returns
write_instruction:
	push {LR}

	#Set RS=0,RW=0,E=0
	ldr R1, =(GPIOC_BASE+GPIO_ODR)
	mov R2, #3<<8
	bic R3, R1, R2
	str R3, [R1]

	#Set E=1
	ldr R1, =(GPIOC_BASE + GPIO_ODR)
	mov R2, #0x1<<8
	orr R3, R1, R2
	str R3, [R1]

	#Set R0 -> DataBus

	#Set E=0
	ldr R1, =(GPIOC_BASE + GPIO_ODR)
	mov R2, #0x1<<8
	bic R3, R1, R2
	str R3, [R1]

	#Wait for appropriate delay
	mov R1, #37
	bl delay_us

	pop {PC}



#Writes data
#RS=0 RW=0  R0-Arg
#No returns
write_data:
	push {LR}

	#Set RS=1,RW=0,E=0

	#Set E=1

	#Set R0 -> DataBus

	#Set E=0

	#Wait for appropriate delay

	pop {PC}

#Write other global functions

@ Clears the screen
@ includes delay
lcd_clear:
	push {R0, LR}

	mov R0, #0x01
    bl write_instruction

	pop  {PC}

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
	push {LR}
	pop  {PC}

@ Prints a decimal number to the display
@ can only print number between 0 and 9999
@ includes delay
@
@ R1 : input : the binary number to print
lcd_print_num:
	push {LR}
	pop  {PC}

#Helper function you probably want to move somewhere else...
# about r1 mircoseonds
delay_us:
	push {R1, LR}

	lsl R1, R1, #3

1:
	subs R1, R1, #1
	bne 1b

	pop {R1, PC}
