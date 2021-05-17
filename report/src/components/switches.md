# Switches

## Overview

The DE10-Lite comes prequipped with 10 slide switches.

## Memory Map

The component utilizes 10 bits, 1 for each switch.

```
+----------+-----+-----+----------+----------+----------+
| Switch 9 | ... | ... | Switch 2 | Switch 1 | Switch 0 |
+----------+-----+-----+----------+----------+----------+
```

## Theory of Operation

Nothing needs to be initialized. Simply read the memory itself or use the api calls.

## Hardware Connections

The components is hardwired to the switches on the board

## Testing and Usage

```c
#include "switches.h"

while (1)
{
	printf("Value: %d\n", read_switches());
}
```