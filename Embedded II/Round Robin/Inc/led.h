/**
 ******************************************************************************
 * @file embedded.h
 * @author John Bretz
 * @version V1.0
 * @brief Function prototypes
 ******************************************************************************
 */

/*
 * Sets up the LED array for use
 */
void LED_INIT(void);

/*
 * Displays a ten bit binary number on the LED array
 */
void light_LED(int number);

void led_delay(void);