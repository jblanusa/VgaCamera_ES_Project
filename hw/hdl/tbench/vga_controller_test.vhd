library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.vga_pkg.all;

entity vga_controller_test is
	port
	(
		vga_clk : in std_logic;
		master_clk: in std_logic;
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
      	VGA_BOARD_ID        : inout std_logic;
		
		-- Avalon slave signals
		mm_params_address 		: in std_logic_vector(27 downto 0);
		mm_params_read			: in std_logic;
		mm_params_readdata 		: out std_logic_vector (31 downto 0);
		mm_params_write 		: in std_logic;
		mm_params_writedata 	: in std_logic_vector(31 downto 0);
		mm_params_waitrequest 	: out std_logic
		  );
end vga_controller_test;


architecture rtl of vga_controller_test is
	
	-- Avalon master signals emulation
	signal master_address 		: std_logic_vector (31 downto 0);
	signal master_read			: std_logic;
	signal master_readdata		: std_logic_vector(31 downto 0);
	signal master_readdatavalid 	: std_logic;	
	signal master_waitrequest	: std_logic;	
	signal master_burstcount		: std_logic_vector(5 downto 0);

begin

	-- VGA_sync component
	--
	I_VGA_CONT: component VGA_controller
		port map(
		vga_clk => vga_clk,
		master_clk => master_clk,
		reset => reset,
		
		-- Conduit signals
		VGA_VIDEO_R         => VGA_VIDEO_R, 
      	VGA_VIDEO_G         => VGA_VIDEO_G,
      	VGA_VIDEO_B         => VGA_VIDEO_B,
      	VGA_VIDEO_HSYNC     => VGA_VIDEO_HSYNC,
      	VGA_VIDEO_VSYNC     => VGA_VIDEO_VSYNC,
      	VGA_VIDEO_CLK       => VGA_VIDEO_CLK,
      	VGA_CAM_PAL_VGA_SCL => VGA_CAM_PAL_VGA_SCL,
      	VGA_CAM_PAL_VGA_SDA => VGA_CAM_PAL_VGA_SDA, 
      	VGA_BOARD_ID        => VGA_BOARD_ID,
		
		-- Avalon master signals
		mm_paramm_address 		 => master_address,
		mm_paramm_read			 => master_read,
		mm_paramm_readdata		 => master_readdata,
		mm_paramm_readdatavalid  => master_readdatavalid,
		mm_paramm_waitrequest	 => master_waitrequest,
		mm_paramm_burstcount	 => master_burstcount,
		
		-- Avalon slave signals
		mm_params_address 		 => mm_params_address,
		mm_params_read			 => mm_params_read,
		mm_params_readdata 		 => mm_params_readdata,
		mm_params_write 		 => mm_params_write,
		mm_params_writedata 	 => mm_params_writedata,
		mm_params_waitrequest 	 => mm_params_waitrequest
		);

   -- Master driver component
   --
   I_DRIVER : component master_driver
   		port map(
	   		clk_50 	=> master_clk,
			rst  	=> reset,
			--Avalon master bus
			mm_paramm_address 	=> master_address,
			mm_paramm_read 		=> master_read,
			mm_paramm_readdata 	=> master_readdata,
			mm_paramm_readdatavalid => master_readdatavalid,	
			mm_paramm_waitrequest 	=> master_waitrequest, 	
			mm_paramm_burstcount	=> master_burstcount	
   		);
	


end rtl;
