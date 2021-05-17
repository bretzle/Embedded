# Accelerometer

## Overview

The accelerometer is a sensor build into the board that can detect movements on all 3 axes.

## Memory Map

## Theory of Operation

Internally the device uses an I2C bus to communicate with the rest of the system. The component must be initialized prior to retrieving data from the device. This device does not make use of interrupts.

## Hardware Connections

Uses the accelerometer's pins more specifically:

| Name            | Direction | Purpose                   |
|-----------------|-----------|---------------------------|
| `G_SENSOR_SDO`  | inout     | I2C address select        |
| `G_SENSOR_SDI`  | inout     | I2C serial data           |
| `G_SENSOR_SCLK` | inout     | I2C serial clock          |
| `G_SENSOR_CS_N` | out       | Enables I2C communication |

*See DE10-Lite [Manual](https://www.intel.com/content/dam/altera-www/global/en_US/portal/dsn/42/doc-us-dsnbk-42-2912030810549-de10-lite-user-manual.pdf) for FPGA pins*


## Testing and Usage

```c
#include "accel.h"

accel_init();

int16_t data[3];

get_accel_data(data);
```