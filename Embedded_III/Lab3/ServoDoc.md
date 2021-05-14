# Servo Controller

## Overview

A controller for the SG90 Servo Motor. The SG90 has 90 degrees of movement.

## Memory Map & Register Usage

| Signal | Direction | Description            |
| ------ | --------- | ---------------------- |
| CLK    | in        | 50MHz clock            |
| RST    | in        | Active high reset      |
| DATA   | in        | 8-bit data bus         |
| PWM    | out       | Wave that drives servo |

## Theory

The **PWM** signal is generated based on **DATA**. A proper signal is generated when **DATA** is between 0 and 200. Where 0 is 0 degrees and 200 is 90 degrees. When **DATA** is larger than 200 there is no output. (**PWM** is '0') 

## Hardware Connections

**CLK** is mapped to the system clock.

**RST** is hard wired to '0'

**DATA** is memory mapped using a Avalon PIO

**PWM** is mapped to an arduino pin. That can be attached to the servo itself.

## Usage

```c
#include "servo.h"

// Continuosly move the servo to a random position
char stored = -1;
while (1)
{
	char value = random_char();
	if (stored != value)
	{
		move_servo(SERVO_1, value);
		stored = value;
    }
}
```