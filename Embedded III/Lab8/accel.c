//! John Bretz
//! CE2820
//! accel.h
//! accelerometer api impl

#include <stdint.h>
#include <unistd.h>
#include "altera_avalon_i2c.h"
#include "system.h"

static ALT_AVALON_I2C_DEV_t *i2c_dev = NULL;

int accel_init(void)
{
	ALT_AVALON_I2C_STATUS_CODE status;
	uint8_t txbuffer[2];

	i2c_dev = alt_avalon_i2c_open(I2C_ACCEL_NAME);
	if (i2c_dev == NULL)
		return -1;

	alt_avalon_i2c_master_target_set(i2c_dev, 0x53);

	txbuffer[0] = 0x31;
	txbuffer[1] = 0x0B;

	status = alt_avalon_i2c_master_tx(i2c_dev, txbuffer, 2, ALT_AVALON_I2C_NO_INTERRUPTS);
	if (status != ALT_AVALON_I2C_SUCCESS)
		return -1;

	txbuffer[0] = 0x2D;
	txbuffer[1] = 0x08;

	status = alt_avalon_i2c_master_tx(i2c_dev, txbuffer, 2, ALT_AVALON_I2C_NO_INTERRUPTS);
	if (status != ALT_AVALON_I2C_SUCCESS)
		return -1;

	return 0;
}

int get_accel_data(int16_t storage[3])
{
	uint8_t tx[1] = {0x32};
	ALT_AVALON_I2C_STATUS_CODE status = alt_avalon_i2c_master_tx_rx(i2c_dev, tx, 1, (uint8_t *)storage, 6, ALT_AVALON_I2C_NO_INTERRUPTS);
	if (status != ALT_AVALON_I2C_SUCCESS)
		return -1;

	return 0;
}
