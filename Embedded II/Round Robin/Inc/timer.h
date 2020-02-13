
#ifndef TIMER_H
#define TIMER_H

typedef struct {
	int CR1;
	int CR2;
	int SMCR;
	int DIER;
	int SR;
	int EGR;
	int CCMR1;
	int CCMR2;
	int CCER;
	int CNT;
	int PSC;
	int ARR;
	int RCR;
	int CCR1;
	int CCR2;
	int CCR3;
	int CCR4;
	int BDTR;
	int DCR;
	int DMAR;
} TIM;

#define TIM1_BASE 0x40010000

void init_tim1(void);

#endif