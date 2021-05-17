# Servo

## Overview

The system has two servo controllers that can control two independant hobby servo motors. 

## Memory Map

Each servo is effectivly an 8-bit register.

## Theory of Operation

Nothing needs to be initialized in software.

The value determines the position of the servo. Eacg servo has `90`° of movement. When the register holds `0`-`200` the servo will move from `0`-`90`°. If the value is `>200` the servo will "turn off" (Allowing free range of motion)

Internally the controller creates a pwm signal that will tell the servo the position to move to.

## Hardware Connections

Each servo will require a connection to VCC (+5V), GND, and an arduino pin to drive.


## Testing and Usage

```c
#include "servo.h"

// Move the first servo to 45° and the second to 90°
move_servos_degree(45, 90);
```