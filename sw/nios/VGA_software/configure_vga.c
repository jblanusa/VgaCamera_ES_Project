/*
 * configure_vga.c
 *
 *  Created on: Dec 16, 2016
 *      Author: Korisnik
 */
#include <assert.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "sys/alt_cache.h"

typedef unsigned char  byte;
typedef unsigned short word;
typedef unsigned long  dword;

#include "system.h"
#include "io.h"

#include "configure_vga.h"
#include "vga_registers.h"

void init_vga(){
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_DISPCOM, COMM_STOP); //Command stop

	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_FBadd, HPS_0_BRIDGES_BASE);
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_FBlen, H_DISPLAY*V_DISPLAY);
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_HBP, H_BP); //HBP
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_HFP, H_FP); //HFP
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_VBP, V_BP); //VBP
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_VFP, V_FP); //VFP
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_HDATA, H_DISPLAY); //Hdata
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_VDATA, V_DISPLAY); //Vdata
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_HSYNC, H_SYNC); //HSync
	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_VSYNC, V_SYNC); //VSync

	 IOWR(VGA_CONTROLLER_0_BASE, VGA_REG_DISPCOM, COMM_START); //Command start
}

void write_test_image(){
	  uint32_t megabyte_count = 0;
	  uint32_t i, row, col;
//	  uint32_t test_image[H_DISPLAY][V_DISPLAY];
	  uint32_t red = 0xFF000000;
	  uint32_t white = 0x00FF0000;
      uint32_t writedata;

	  for(i = 0; i < IMAGE_SIZE; i += sizeof(uint32_t)) {

	      uint32_t addr = HPS_0_BRIDGES_BASE + i;

	      // Write through address span expander
	      row = (i/4) / H_DISPLAY;
	      col = (i/4) % H_DISPLAY;

	      if(row == 10 )
	    	  writedata = 0x0000FF00;
	      else{
	      if((col >= 240) && (col <= 400) && (row >= 160) && (row <= 320))
	    	  writedata = red;
	      else
	    	  writedata = white;
	      }
	      IOWR(addr, 0, writedata);

	      // Read through address span expander
	      uint32_t readdata = IORD(addr, 0);

	      if (col == 200) {
	      	          printf("Read data, row %d, data = %x\n", row, readdata );
	      	      }

	      assert(writedata == readdata);
	  }
}


void load_image(){
	  int i, j;
	  FILE*	fp1 =  NULL;
	  byte header = 0 ;
	  word BitsPerPixel = 0;
	  dword offset = 0, height = 0, width = 0;
	  dword address, dataR, dataG, dataB, data;

	  fp1  = fopen ("/mnt/host/test5.bmp", "rb");
	  if (fp1 ==	NULL)
	  {
		  printf ("Cannot	open file test.bmp.\n");
		  exit (1);
	  }
	  //checking picture regularity
	 if (fgetc (fp1) != 'B' || fgetc (fp1) != 'M')
	 {
		 fclose (fp1);
		 printf ("%s is not a bitmap file.\n",fp1);
		 exit (1);
	 }
	 printf("Pocetak citanja\n");
	 //header reading
	 for (i = 1; i < 53; i++){
		 header = fgetc(fp1);
		 switch (i)
		 {
		 case 17: width += header; break;
		 case 18: width += header * 256; break;
		 case 19: width += header * 256 * 256; break;
		 case 20: width += header * 256 * 256 * 256; break;
		 case 21: height += header; break;
		 case 22: height += header * 256; break;
		 case 23: height += header * 256 * 256; break;
		 case 24: height += header * 256 * 256 * 256; break;
		 case 27: BitsPerPixel += header; break;
		 case 28: BitsPerPixel += header * 256; break;
		 case 45: offset += header; break;
		 case 46: offset += header * 256; break;
		 case 47: offset += header * 256 * 256; break;
		 case 48: offset += header * 256 * 256 * 256; break;
		 default: break;
		 }
	 }
	 //offset reading
	 offset *= 4;
	 for (i = 0; i < offset; i++)
	 {
		 header=fgetc(fp1);
	 }


	 if (BitsPerPixel == 24){
		 address = 0;
		 for (i = height-1; i >= 0; i--){
			 for(j = 0; j < width; j++){
				 address = (i * width + j) * 4;
				 dataB = fgetc(fp1);
				 dataG = fgetc(fp1);
				 dataR = fgetc(fp1);
			//	 data = (dataR << 8) + (dataG << 16) + (dataB << 24);
				 IOWR_8DIRECT(HPS_0_BRIDGES_BASE, address, dataR);
				 IOWR_8DIRECT(HPS_0_BRIDGES_BASE, address+1, dataR);
				 IOWR_8DIRECT(HPS_0_BRIDGES_BASE, address+2, dataG);
				 IOWR_8DIRECT(HPS_0_BRIDGES_BASE, address+3, dataB);
				 address += 4;
			 }
			// printf("Red %d gotov\n", i);
		 }
	 }

	fclose (fp1);
}
