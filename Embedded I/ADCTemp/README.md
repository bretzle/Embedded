# ADC Temperature

Use a analog temperature sensor and an ADC to read the temperature of the room and write the temperature to a display

## Commands

| Key | Command Name             | Description                                                          | Done               |
| --- | ------------------------ | -------------------------------------------------------------------- |:------------------:|
| \*  | Buffer mode              | When on, all samples are stored in RAM                               | :x:                |
| #   | Set interval             | Allows user to set interval between samples            (1-9 seconds) | :heavy_check_mark: |
| B   | Set buffer size          | Set the size of buffer (1 - 9 samples)                               | :heavy_check_mark: |
| D   | Toggle display unit      | Toggle between °C and °F                                             | :heavy_check_mark: |
| A   | Display buffered results |                                                                      | :x:                |
| C   | Continuous Mode          | Display results as they are computed                                 | :x:                |

- [x] Convert analog signal to mV

- [x] Convert mV into a °C and °F

- [x] Modularize ADC

- [x] Transform temperature number into a human readable form

- [x] Have samples collected via timer interrupts

- [ ] Work on commands
