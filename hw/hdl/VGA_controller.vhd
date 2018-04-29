library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vga_pkg.all;

entity VGA_controller is
	port
	(
		vga_clk : in std_logic;
		master_clk : in std_logic;
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
      	
      	-- Debug conduits
		DISPLAY_COM_OUT	  : out std_logic;
		DISPLAY_STAT_OUT	  : out std_logic;
		FIFO_EMPTY	: out std_logic;
		FIFO_FULL 	: out std_logic;
		FIFO_HALF	: OUT std_logic;
		WAITREQ		: out std_logic;
		READVALID	: out std_logic;
		MASTER_STATE : out std_logic_vector(2 downto 0);
		MASTER_READ : out std_logic;
		BURST_COUNT : out std_logic_vector(5 downto 0);
		
		-- Avalon master signals
		mm_paramm_address 		: out std_logic_vector (31 downto 0);
		mm_paramm_byteenable	: out std_logic_vector (3 downto 0); -- NOVI
		mm_paramm_read			: out std_logic;
		mm_paramm_readdata		: in std_logic_vector(31 downto 0);
		mm_paramm_readdatavalid : in std_logic;	
		mm_paramm_waitrequest	: in std_logic;	
		mm_paramm_burstcount	: out std_logic_vector(5 downto 0);
		
		-- Avalon slave signals
		mm_params_address 		: in std_logic_vector(27 downto 0);
		mm_params_read			: in std_logic;
		mm_params_readdata 		: out std_logic_vector (31 downto 0);
		mm_params_write 		: in std_logic;
		mm_params_writedata 	: in std_logic_vector(31 downto 0);
		mm_params_waitrequest 	: out std_logic
	);
end VGA_controller;


architecture rtl of VGA_controller is
	
	-- vga signals
	signal HBP_top, HFP_top, VBP_top, VFP_top, Hdata_top, Vdata_top, HS_top, VS_top : unsigned(15 downto 0);
	signal hsync_top, vsync_top : std_logic;
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
	signal FBAdd_top 		: unsigned (31 downto 0);
	signal FBLen_top 		: unsigned (20 downto 0);
	signal DisplayStat_top  : unsigned (15 downto 0);
	
	-- Debug
	signal mstate : unsigned(2 downto 0);
	signal altera_read : std_logic;
	signal altera_bcount : std_logic_vector(5 downto 0);
begin
	
--	R_fifo_out <= fifo_data_out(15 downto 8); --B G R 0
--	G_fifo_out <= fifo_data_out(23 downto 16);
--	B_fifo_out <= fifo_data_out(31 downto 24);

	B_fifo_out <= fifo_data_out(7 downto 0);
	G_fifo_out <= fifo_data_out(15 downto 8);
	R_fifo_out <= fifo_data_out(23 downto 16);
	
--	write_halffull <= '1' when wr_used = "10000" else
--					  '0';
	write_halffull <=  '1' when (unsigned(wr_used) < 32 and write_full = '0' and unsigned(wr_used) /= 0) else
					   '0';
					  
	FIFO_HALF <= write_halffull;
	
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
			hsync => hsync_top,
			vsync => vsync_top,
			HBP =>  HBP_top,
			HFP =>  HFP_top,
			VBP =>  VBP_top,
			VFP =>  VFP_top,
			Hdata =>  Hdata_top,
			Vdata =>  Vdata_top,
			HS =>  HS_top,
			VS =>  VS_top
		);
	
	VGA_VIDEO_HSYNC <= hsync_top;
	VGA_VIDEO_VSYNC <= vsync_top;
	VGA_VIDEO_CLK  <= vga_clk;
	
	VGA_CAM_PAL_VGA_SCL <= '0';
	VGA_CAM_PAL_VGA_SDA <= '0';
	VGA_BOARD_ID <= '0';
	
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
	FIFO_FULL <= write_full;
	FIFO_EMPTY <= write_empty;
	
   -- Avalon slave component
   --
   I_SLAVE : component Slave_component
      port map (
	      	rst => reset,
			clk_50 => master_clk,
			-- VGA_display
			VGA_VSync => vsync_top,
			HBP =>  HBP_top,
			HFP =>  HFP_top,
			VBP =>  VBP_top,
			VFP =>  VFP_top,
			Hdata =>  Hdata_top,
			Vdata =>  Vdata_top,
			Hsync => HS_top,
			VSync => VS_top,
			-- Master_component
			DisplayCom => DisplayCom_top,
			FBAdd => FBAdd_top,
			FBLen => FBLen_top,
			DisplayStat => DisplayStat_top,
			--Avalon bus
			mm_params_address => mm_params_address,
			mm_params_read => mm_params_read,
			mm_params_readdata => mm_params_readdata,
			mm_params_write => mm_params_write,
			mm_params_writedata => mm_params_writedata,
			mm_params_waitrequest => mm_params_waitrequest
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
		empty => read_empty,
		--Slave_component
		DisplayCom => DisplayCom_top,
		FBAdd => FBAdd_top,
		FBLen => FBLen_top,
		DisplayStat => DisplayStat_top,
		-- Debug
		state_out => mstate,
		disp_com_out => DISPLAY_COM_OUT,
		is_idle => DISPLAY_STAT_OUT,
		--Avalon bus
		mm_paramm_address => mm_paramm_address,
		mm_paramm_byteenable  => mm_paramm_byteenable,
		mm_paramm_read	  => altera_read,--mm_paramm_read,
		mm_paramm_readdata => mm_paramm_readdata,
		mm_paramm_readdatavalid => mm_paramm_readdatavalid,
		mm_paramm_waitrequest => mm_paramm_waitrequest,
		mm_paramm_burstcount => altera_bcount--mm_paramm_burstcount
		);
		
		mm_paramm_read  <= altera_read;
		mm_paramm_burstcount <= altera_bcount;
		MASTER_STATE <= std_logic_vector(mstate);
		WAITREQ <= mm_paramm_waitrequest;
		READVALID <= mm_paramm_readdatavalid;
		MASTER_READ <= altera_read;
		BURST_COUNT <= altera_bcount;
end rtl;
