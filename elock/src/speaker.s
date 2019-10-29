# speaker.s
# John Bretz
# CE 2801
# Lab 5
# Description: speaker api file

.syntax unified
.cpu cortex-m4
.thumb
.section .text

.global speaker_init

speaker_init:
	push {LR}
	pop  {PC}
