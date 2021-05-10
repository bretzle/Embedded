//! John Bretz
//! CE2820
//! main.c
//! entrypoint
//!
//! Repeatedly gets data from the accelerometer and prints
//! it to stdout

#include <stdint.h>
#include <unistd.h>
#include "accel.h"

int main()
{
  accel_init();
  int16_t accel_data[3];

  while (1)
  {
    if (get_accel_data(accel_data) != 0)
      printf("Error: getting accel data\n");

    printf("X: %10d, Y: %10d, Z: %10d\n", accel_data[0], accel_data[1], accel_data[2]);
    usleep(10000);
  }

  return 0;
}
