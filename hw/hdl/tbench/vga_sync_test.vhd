library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.vga_pkg.all;

entity vga_test is
	port
	(
		vga_clk : in std_logic;
		reset : in std_logic;
		
		-- Conduit signals
		VGA_VIDEO_R         : out   std_logic_vector(7 downto 0);
      	VGA_VIDEO_G         : out   std_logic_vector(7 downto 0);
      	VGA_VIDEO_B         : out   std_logic_vector(7 downto 0);
      	VGA_VIDEO_HSYNC     : out   std_logic;
      	VGA_VIDEO_VSYNC     : out   std_logic;
      	VGA_VIDEO_CLK       : out   std_logic;
      	VGA_CAM_PAL_VGA_SCL : out   std_logic;
      	VGA_CAM_PAL_VGA_SDA : inout std_logic;
      	VGA_BOARD_ID        : inout std_logic
       
		  );
end vga_test;


architecture rtl of vga_test is

	-- vga signals
	signal hpos_tb, vpos_tb : unsigned(15 downto 0);
	signal R_tb, G_tb, B_tb : std_logic_vector(7 downto 0);

begin
	
	VGA_CAM_PAL_VGA_SCL <= '0';
	VGA_CAM_PAL_VGA_SDA <= '0';
	VGA_BOARD_ID <= '0';
	VGA_VIDEO_CLK <= vga_clk;
	-- VGA_sync component
	--
	I_VGA: component vga_sync
		port map(
			clk => vga_clk,
			reset => reset,
			hpos => hpos_tb,
			vpos => vpos_tb,
			fifo_empty =>  '0',
			fifo_full => '1',
			new_pixel => open,
			Rin => R_tb,
			Gin => G_tb,
			Bin => B_tb,
			Rout => VGA_VIDEO_R,
			Gout => VGA_VIDEO_G,
			Bout => VGA_VIDEO_B,
			hsync => VGA_VIDEO_HSYNC,
			vsync => VGA_VIDEO_VSYNC,
			HBP =>  H_BP,
			HFP =>  H_FP,
			VBP =>  V_BP,
			VFP =>  V_FP,
			Hdata =>  H_DISPLAY,
			Vdata =>  V_DISPLAY,
			HS =>  H_SYNC,
			VS =>  V_SYNC
		);

	
   -- fifo component
   --
	igen: component image_gen
		port map(
			hpos => to_integer(hpos_tb),
			vpos => to_integer(vpos_tb),
			Rout => R_tb,
			Gout => G_tb,
			Bout => B_tb	
		);

end rtl;
