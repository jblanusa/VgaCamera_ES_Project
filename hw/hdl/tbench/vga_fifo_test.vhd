library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.vga_pkg.all;

entity vga_fifo_test is
	port
	(
		vga_clk : in std_logic;
		main_clk : in std_logic;
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
end vga_fifo_test;


architecture rtl of vga_fifo_test  is
	
	signal hpos_tb : unsigned(15 downto 0);
	signal vpos_tb : unsigned(15 downto 0);
	
	signal R_fifo_in, G_fifo_in, B_fifo_in : std_logic_vector(7 downto 0);
	signal R_fifo_out, G_fifo_out, B_fifo_out : std_logic_vector(7 downto 0);
	signal Rout_tb, Gout_tb, Bout_tb : std_logic_vector(7 downto 0);
	signal hsync_tb, vsync_tb : std_logic;
	signal npix_tb : std_logic;
	
	-- fifo signals
	signal data_in, data_out : std_logic_vector(31 downto 0);
	signal read_full, read_empty : std_logic;
	signal write_full, write_empty, write_halffull : std_logic;
	signal write_req, read_req : std_logic;
	signal wr_used : std_logic_vector(5 downto 0);
	signal aclr_tb : std_logic;
	
	signal done : boolean := false;
begin
		
--	data_in <= (15 downto 10 => R_fifo_in(7 downto 2), 23 downto 18 => G_fifo_in(7 downto 2), 31 downto 26 => B_fifo_in(7 downto 2), others => '0');
	data_in(15 downto 8)  <= R_fifo_in;
	data_in(23 downto 16) <= G_fifo_in;
	data_in(31 downto 24) <= B_fifo_in;
	data_in(7 downto 0) <= (others => '0');
	
	R_fifo_out <= data_out(15 downto 8);
	G_fifo_out <= data_out(23 downto 16);
	B_fifo_out <= data_out(31 downto 24);
	
	read_req <= npix_tb;
	write_halffull <=  '1' when (unsigned(wr_used) < 48 and write_full = '0' and unsigned(wr_used) /= 0) else
					   '0';
	-- VGA_sync component
	--
	vga: component vga_sync
		port map(
			clk => vga_clk,
			reset => reset,
			hpos => hpos_tb,
			vpos => vpos_tb,
			fifo_empty => read_empty,
			fifo_full => read_full,
			new_pixel => npix_tb,
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

	VGA_VIDEO_CLK <= vga_clk;
  	VGA_CAM_PAL_VGA_SCL <= '0';
  	VGA_CAM_PAL_VGA_SDA <= '0';
  	VGA_BOARD_ID <= '0';
  	 
	-- Input image generator component
	--
	igen: component fifo_input_gen
		port map(
			clk => main_clk,
			rst => reset,
			fifo_empty => write_empty,
			fifo_full => write_full,
			fifo_halffull => write_halffull,
			fifo_write => write_req,
			fifo_clr => aclr_tb,
			Rout => R_fifo_in,
			Gout => G_fifo_in,
			Bout => B_fifo_in	
		);

   -- fifo component
   --
   I_FIFO : component fifo64
      port map (
        aclr => aclr_tb,
		data  => data_in,
		rdclk => vga_clk,
		rdreq => read_req,
		wrclk  => main_clk,
		wrreq  => write_req,
		q => data_out,
		rdempty  => read_empty,
		rdfull  => read_full,
		wrempty => write_empty,
		wrfull => write_full,
		wrusedw => wr_used
		);
		


end rtl;
