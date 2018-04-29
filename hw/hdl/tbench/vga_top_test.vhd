library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.vga_pkg.all;

entity vga_top_test is
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
      	VGA_BOARD_ID        : inout std_logic
       
		  );
end vga_top_test;


architecture rtl of vga_top_test is
	
	-- vga signals
	signal R_fifo_out, G_fifo_out, B_fifo_out : std_logic_vector(7 downto 0);
	
	-- fifo signals
	signal fifo_data_in, fifo_data_out : std_logic_vector(31 downto 0);
	signal write_full, write_empty, write_halffull : std_logic;
	signal write_req, read_req : std_logic;
	signal read_full, read_empty : std_logic;
	signal wr_used : std_logic_vector(5 downto 0);
	signal aclr_top : std_logic;
	
	-- Master-slave communication	
	signal DisplayCom_top 	: unsigned (15 downto 0);
	signal FBAdd_top 		: unsigned (25 downto 0);
	signal FBLen_top 		: unsigned (20 downto 0);
	signal DisplayStat_top  : unsigned (15 downto 0);
	
	-- Avalon master signals emulation
	signal master_address 		: std_logic_vector (31 downto 0);
	signal master_read			: std_logic;
	signal master_readdata		: std_logic_vector(31 downto 0);
	signal master_readdatavalid 	: std_logic;	
	signal master_waitrequest	: std_logic;	
	signal master_burstcount		: std_logic_vector(5 downto 0);

begin
	R_fifo_out <= fifo_data_out(15 downto 8);
	G_fifo_out <= fifo_data_out(23 downto 16);
	B_fifo_out <= fifo_data_out(31 downto 24);
	
	write_halffull <=  '1' when (unsigned(wr_used) < 32 and write_full = '0' and unsigned(wr_used) /= 0) else
					   '0';
	
	-- VGA_sync component
	--
	I_VGA: component vga_sync
		port map(
			clk => vga_clk,
			reset => reset,
			hpos => open,
			vpos => open,
			fifo_empty => read_empty,
			fifo_full => read_full,
			new_pixel => read_req,
			Rin => R_fifo_out,
			Gin => G_fifo_out,
			Bin => B_fifo_out,
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

	VGA_CAM_PAL_VGA_SCL <= '0';
	VGA_CAM_PAL_VGA_SDA <= '0';
	VGA_BOARD_ID <= '0';
	VGA_VIDEO_CLK <= vga_clk;
	
   -- fifo component
   --
   I_FIFO : component fifo64
      port map (
        aclr  => aclr_top,
		data  => fifo_data_in,
		rdclk => vga_clk,
		rdreq => read_req,
		wrclk => master_clk,
		wrreq => write_req,
		q 	  => fifo_data_out,
		rdempty => read_empty,
		rdfull  => read_full,
		wrempty => write_empty,
		wrfull  => write_full,
		wrusedw => wr_used
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
	
	
   -- Avalon master component
   --
   I_MASTER : component Master_component
      port map (
        clk_50 => master_clk,
		rst => reset,
		--FIFO
		aclr => aclr_top,
		data_out => fifo_data_in,
		en_in => write_req,
		half => write_halffull,
		empty => write_empty,
		--Slave_component
		DisplayCom => to_unsigned(1,16),
		FBAdd => to_unsigned(0,32),
		FBLen => to_unsigned(640*480,21),
		DisplayStat => to_unsigned(0,16),
		--Avalon bus
		mm_paramm_address 	=> master_address,
		mm_paramm_read 		=> master_read,
		mm_paramm_readdata 	=> master_readdata,
		mm_paramm_readdatavalid => master_readdatavalid,	
		mm_paramm_waitrequest 	=> master_waitrequest, 	
		mm_paramm_burstcount	=> master_burstcount	
		);

end rtl;
