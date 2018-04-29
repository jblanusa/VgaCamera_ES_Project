#include <assert.h>
#include <inttypes.h>
#include <stdio.h>

#include "i2c.h"

#include "io.h"
#include "system.h"
#include "configure_vga.h"
#include "vga_registers.h"

#define I2C_FREQ              (50000000) /* Clock frequency driving the i2c core: 50 MHz in this example (ADAPT TO YOUR DESIGN) */
#define TRDB_D5M_I2C_ADDRESS  (0xba)
//I2C_0_BASE

bool trdb_d5m_write(i2c_dev *i2c, uint8_t register_offset, uint16_t data) {
    uint8_t byte_data[2] = {(data >> 8) & 0xff, data & 0xff};

    int success = i2c_write_array(i2c, TRDB_D5M_I2C_ADDRESS, register_offset, byte_data, sizeof(byte_data));

    if (success != I2C_SUCCESS) {
        return false;
    } else {
        return true;
    }
}

bool trdb_d5m_read(i2c_dev *i2c, uint8_t register_offset, uint16_t *data) {
    uint8_t byte_data[2] = {0, 0};

    int success = i2c_read_array(i2c, TRDB_D5M_I2C_ADDRESS, register_offset, byte_data, sizeof(byte_data));

    if (success != I2C_SUCCESS) {
        return false;
    } else {
        *data = ((uint16_t) byte_data[0] << 8) + byte_data[1];
        return true;
    }
}

int main()
{
    i2c_dev i2c = i2c_inst((void *) I2C_0_BASE);
    i2c_init(&i2c, I2C_FREQ);


    uint16_t readdata = 0;
    // restart
    trdb_d5m_read(&i2c, 0x0B, &readdata);
    readdata |= 1;
    trdb_d5m_write(&i2c, 0x0B, readdata);

    // mirror
/*    trdb_d5m_read(&i2c, 0x20, &readdata);
    readdata |= (1<<15);
    trdb_d5m_write(&i2c, 0x20, readdata);*/
    	// mirror column
 /*   trdb_d5m_read(&i2c, 0x20, &readdata);
	readdata |= (1<<14);
	trdb_d5m_write(&i2c, 0x20, readdata);*/
 /*   trdb_d5m_read(&i2c, 0x20, &readdata);
    readdata &= ~(1<<15);
    trdb_d5m_write(&i2c, 0x20, readdata);*/
    // resolution

    // column size
    readdata = 1279;
    trdb_d5m_write(&i2c, 0x04, readdata);

    // row size
    readdata = 1023;
    trdb_d5m_write(&i2c, 0x03, readdata);

	init_vga();
//	IOWR_32DIRECT(CAMERA_CONTROLLER_0_BASE, 8, 0x00000001);
	IOWR_32DIRECT(CAMERA_CONTROLLER_0_BASE, 0, 0x00000001);
	int i;
//	IOWR_32DIRECT(CAMERA_CONTROLLER_0_BASE, 0, 0x00000003);
	printf("Camera done");
	while(1){}
}
