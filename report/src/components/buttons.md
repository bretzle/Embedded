# Push Buttons

## Overview

The board comes equiped with two push buttons.

## Memory Map

Each button takes up 2 bits in memory.

'1' is pressed. '0' is not pressed

```
+----------+----------+
| Button 2 | Button 1 |
+----------+----------+
```

## Theory of Operation

Nothing needs to be initialized. Simply read the memory itself or use the api calls.

## Hardware Connections

The component is hardwired to the buttons on the board

## Testing and Usage

```c
#include "pushbutton.h"

while (1)
{
	if (is_button_pressed(BUTTON_1))
	{
		printf("Button 1 is pressed!\n");
	}
}
```