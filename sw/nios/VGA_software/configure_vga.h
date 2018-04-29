/*
 * configure_vga.h
 *
 *  Created on: Dec 16, 2016
 *      Author: Korisnik
 */

#ifndef CONFIGURE_VGA_H_
#define CONFIGURE_VGA_H_

// VGA timing parameters
// 640x480@60Hz
// Horiontal line
#define H_SYNC 96   // sync pulse in pixels
#define H_BP   48	// back porch in pixels
#define H_FP   16	// front porch in pixels
#define H_DISPLAY  640	// visible pixels
// Vertical line
#define V_SYNC 2	// sync pulse in pixels
#define V_BP  33	// back porch in pixels
#define V_FP  10	// front porch in pixels
#define V_DISPLAY 480	// visible pixels

#define IMAGE_SIZE 640*480*4

// Commands
#define COMM_START 0xFFFF
#define COMM_STOP 0



// Functions
void init_vga();
void init_vga_test();
void load_image();
void write_test_image();


#endif /* CONFIGURE_VGA_H_ */
