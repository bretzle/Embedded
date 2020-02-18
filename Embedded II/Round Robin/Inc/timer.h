
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
#define TIM2_BASE 0x40000000
#define TIM3_BASE 0x40000400
#define TIM4_BASE 0x40000800
#define TIM5_BASE 0x40000C00
#define TIM6_BASE 0x40001000
#define TIM10_BASE 0x40014400

void init_tim2(void);
void init_tim3(void);
void init_tim4(void);
void init_tim10(void);

void enable_tim2_int(TIM*);
void enable_tim3_int(TIM*);
void enable_tim4_int(TIM*);
void enable_tim10_int(TIM*);

void set_arr(TIM*, int);
void set_psc(TIM*, int);
void start(TIM*);
void stop(TIM*);

#endif