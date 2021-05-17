# Hardware Setup

### Top level Schematic

![Top Level Schematic](https://cdn.discordapp.com/attachments/371689406823661570/842882954601824277/unknown.png)

### Board Block Diagram

![Board Block Diagram](https://cdn.discordapp.com/attachments/371689406823661570/843220247725080576/unknown.png)

### Overall Memory Map

| Component             | Start         | End           |
|-----------------------|---------------|---------------|
| LEDs                  | `0xFF20_0000` | `0xFF20_000F` |
| Switches              | `0xFF20_0040` | `0xFF20_004F` |
| Pushbuttons           | `0xFF20_0050` | `0xFF20_005F` |
| HexDecoder            | `0xFF20_2050` | `0xFF20_205F` |
| Servos                | `0xFF20_2060` | `0xFF20_206F` |
| LCD                   | `0xFF20_2070` | `0xFF20_207F` |
| Touch Control         | `0xFF20_2080` | `0xFF20_2087` |
| Joystick Sequencer    | `0xFF20_2090` | `0xFF20_2097` |
| Joystick Sample Store | `0xFF20_2200` | `0xFF20_23FF` |
| Accelerometer         | `0xFF20_2440` | `0xFF20_247F` |
