
#define RCC_APB1ENR 0x40023840
#define RCC_APB2ENR 0x40023844
#define RCC_AHB1ENR 0x40023830
#define NVIC_BASE 0xE000E000

#define ISER0_OFF 0x100

#define GPIOA_BASE 0x40020000
#define GPIOB_BASE 0x40020400
#define GPIOC_BASE 0x40020800

#define RCC_BASE 0x40023800

#define GPIOAEN 1<<0
#define GPIOBEN 1<<1
#define GPIOCEN 1<<2

#define AHB1ENR 0x0C

#define MODER 0
#define PUPDR 3
#define IDR   4
#define ODR   5
#define BSRR  6
#define AFRL  8