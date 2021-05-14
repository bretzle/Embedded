//! John Bretz
//! CE2820
//! accel.h
//! accelerometer api

#ifndef ACCEL_H_
#define ACCEL_H_

#include "stdint.h"

/// Initializes the accelerometer
///
/// @return 0 on success else -1
int accel_init(void);

/// Retrieves data from the accelerometer
///
/// @param storage: array to store [x, y, z] data
/// @return 0 on success else -1
int get_accel_data(int16_t storage[3]);

#endif /* ACCEL_H_ */
