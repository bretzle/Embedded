//! John Bretz
//! CE2820
//! analog.h
//! API for analog stick

#ifndef ANALOG_H_
#define ANALOG_H_

#include <stdint.h>

#define ANALOG_THRESHOLD 10

/// Initializes the ADC's used by the analog stick
void analog_init(void);

/// Reads the analog stick data.
/// Each component will be on the range of -100 to 100
///
/// @param storage: where to store [x, y]
void get_analog_data(int32_t storage[2]);

#endif /* ANALOG_H_ */
