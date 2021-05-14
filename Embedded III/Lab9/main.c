//! John Bretz
//! CE2820
//! main.c
//! entrypoint
//!
//! Demo program
//!
//! Demonstrates every comonent used in the semester.

#include "led.h"
#include "pushbutton.h"
#include "switches.h"
#include "seven_seg.h"
#include "servo.h"
#include "lcd.h"
#include "touch.h"
#include "analog.h"
#include "accel.h"

#include "utils.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct AppState
{
  int32_t joystick[2];
  int16_t accelerometer[3];
  int32_t touch_data[2];
  int16_t led_value;
  int32_t last_switch;
} AppState;

/// Sets the min and max value of a number
static void clamp(int32_t *val, int32_t min, int32_t max)
{
  if (*val > max)
  {
    *val = max;
  }
  else if (*val < min)
  {
    *val = min;
  }
}

/// prints data from the accelerometer to stdout if Button 1 is pressed
void print_accel(AppState *state)
{
  if (is_button_pressed(BUTTON_1))
  {
    printf("X: %10d, Y: %10d, Z: %10d\n", state->accelerometer[0], state->accelerometer[1], state->accelerometer[2]);
    usleep(10000);
  }
}

/// Displays the last location touched
void display_seven_seg(AppState *state)
{
  int number = state->touch_data[0] * 1000 | state->touch_data[1];
  write_hex_display(number, 10);
}

// The LED that is on is controlled by the analog stick
void drive_leds(AppState *state)
{
  const int min = 0x001;
  const int max = 0x200;

  if (state->joystick[0] > ANALOG_THRESHOLD)
    state->led_value >>= 1;
  else if (state->joystick[0] < -ANALOG_THRESHOLD)
    state->led_value <<= 1;

  clamp((int32_t *)&state->led_value, min, max);

  write_leds(state->led_value);
}

// Draws randomly colored lines to screen
void draw_screen(void)
{
  for (int i = 0; i < WIDTH - 1; i++)
  {
    int color = rand() & 0xFFFFFF;
    draw_line(i, 0, i, HEIGHT - 1, color);
  }

  lcd_present();
}

// Move the servos to random positions
void control_servos(void)
{
  int a = rand() & 0xFF;
  int b = rand() & 0xFF;

  move_servos(a, b);
}

void print_switches(AppState *state)
{
  int read = read_switches();

  if (read != state->last_switch)
  {
    state->last_switch = read;
    printf("Switches changed: %d\n", read);
  }
}

int main()
{
  // initialize subsystems
  analog_init();
  accel_init();
  lcd_init();
  touch_init();

  AppState state = {.led_value = 1};

  draw_screen();

  while (1)
  {
    // poll data from peripherals
    get_analog_data(state.joystick);
    get_accel_data(state.accelerometer);
    get_touch_data(state.touch_data);

    // call routines
    print_accel(&state);
    display_seven_seg(&state);
    drive_leds(&state);
    control_servos();
    print_switches(&state);
  }

  return 0;
}
