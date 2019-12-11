
/*
 * Sets up the LED array for use
 */
void LED_INIT(void);

/*
 * A busy wait that will last delay ms
 */
void delay_ms(int delay);

/*
 * Displays a ten bit binary number on the LED array
 */
void light_LED(int number);
