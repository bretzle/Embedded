/* header file */
#include <inttypes.h>

/* all symbolic numbers */
#define F_CPU 16000000UL
#define SYSTICK (volatile uint32_t *) 0xE000E010

/* public method prototypes */
void delay_ms(uint32_t);
void delay_us(uint32_t);
