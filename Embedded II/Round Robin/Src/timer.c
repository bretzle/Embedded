#include "timer.h"
#include "register.h"

volatile static int* apb1enr = (int*) RCC_APB1ENR;
volatile static int* iser0 = (int*) 0xE000E100;

void init_tim2(void) {
    *apb1enr |= 0b01;
}

void init_tim3(void) {
    *apb1enr |= 0b10;
}

void set_arr(TIM* base, int value) {
    base->ARR = value;
}

void set_psc(TIM* base, int value) {
    base->PSC = value;
}

void start(TIM* base) {
    base->CR1 |= 1;
}

void stop(TIM* base) {
    base->CR1 &= ~1;
}

void enable_tim3_int(TIM* base) {
    base->DIER |= 1;
    *iser0 |= 1<<29;
}