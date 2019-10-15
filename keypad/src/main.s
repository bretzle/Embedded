# main.s
# John Bretz
# CE 2801
# Lab 5
# Description: main file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global main

main:
	bl key_init
	bl lcd_init

end:
	b end
