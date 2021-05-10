//! John Bretz
//! CE2820
//! analog.h
//! API for analog stick

#ifndef ANALOG_H_
#define ANALOG_H_

#define ANALOG_THRESHOLD 10

typedef struct AnalogData
{
	/// X component, -100 is left, 100 is right
	int x;
	/// Y component, -100 is down, 100 is up
	int y;
} AnalogData;

/// Initializes the ADC's used by the analog stick
void analog_init(void);

/// Reads the analog stick data.
/// Each component will be on the range of -100 to 100
AnalogData get_analog_data(void);

#endif /* ANALOG_H_ */
