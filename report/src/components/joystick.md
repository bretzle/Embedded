# Joystick

## Overview

An analog joystick similar to those found on game controllers. Allows vector based controls.

![Picture of joystick](https://cdn.discordapp.com/attachments/371689406823661570/843241408223772742/unknown.png)

## Memory Map

## Theory of Operation

The joystick makes use of a general purpose ADC. `Vrx`, `Vry` and `Sw` are connected to arduino ADC pins. Once the ADC is turned on the joystick inputs can be read by the system.

## Hardware Connections

| Name | Direction | Purpose                  | Notes          |
|------|-----------|--------------------------|----------------|
| VCC  | out       | +5V connection           |                |
| GND  | out       | ground connection        |                |
| Vrx  | in        | Horizontal analog signal | Connects to A0 |
| Vry  | in        | Vertical analog signal   | Connects to A1 |
| Sw   | in        | Clicking Switch          | Connects to A2 |


*See DE10-Lite [Manual](https://www.intel.com/content/dam/altera-www/global/en_US/portal/dsn/42/doc-us-dsnbk-42-2912030810549-de10-lite-user-manual.pdf) for FPGA pins*

## Testing and Usage

```c
#include "analog.h"

int32_t data[2];

analog_init();
get_analog_data(data);

printf("X: %10d, Y: %10d\n", data[0], data[1]);
```