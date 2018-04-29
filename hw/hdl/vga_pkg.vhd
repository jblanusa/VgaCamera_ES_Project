library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;

package vga_pkg is
		
	-- Test image, red square
	subtype color is std_logic_vector(23 downto 0);	
								--RRGGBB
	constant BLACK : color   := x"000000";
	constant RED   : color   := x"FF0000";
	constant BLUE   : color   := x"0000FF";
	constant GREEN   : color   := x"00FF00";
	constant WHITE : color := x"FFFFFF";
	
	type row is array(natural range 0 to 639) of color;
	type image is array (natural range 0 to 479) of row;
	
	constant BCKG_ROW : row := (others => BLACK);
	constant  IMG_ROW : row := (240 to 400 => RED, others => BLACK);
	constant RED_SQUARE : image := (160 to 320 => IMG_ROW, others => BCKG_ROW);
	
	-- VGA timing parameters
	-- 640x480@60Hz
	constant H_SYNC	: unsigned(15 downto 0) := to_unsigned(96,16);		-- sync pulse in pixels
	constant H_BP	: unsigned(15 downto 0) := to_unsigned(48,16);		-- back porch in pixels
	constant H_FP	: unsigned(15 downto 0) := to_unsigned(16,16);		-- front porch in pixels
	constant H_DISPLAY : unsigned(15 downto 0) := to_unsigned(640, 16);	-- visible pixels
		-- Vertical line
	constant V_SYNC	: unsigned(15 downto 0) := to_unsigned(2, 16);		-- sync pulse in pixels
	constant V_BP	: unsigned(15 downto 0) := to_unsigned(33,16);		-- back porch in pixels
	constant V_FP	: unsigned(15 downto 0) := to_unsigned(10,16);		-- front porch in pixels
	constant V_DISPLAY: unsigned(15 downto 0) := to_unsigned(480,16);	-- visible pixels

---------------------------------------------------------------------------------------------
-- RTL components
---------------------------------------------------------------------------------------------
	
   -- Altera IP fifo
   --
	component fifo
		PORT
		(
			aclr		: IN STD_LOGIC  := '0';
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			rdclk		: IN STD_LOGIC ;
			rdreq		: IN STD_LOGIC ;
			wrclk		: IN STD_LOGIC ;
			wrreq		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			rdempty		: OUT STD_LOGIC ;
			rdfull		: OUT STD_LOGIC ;
			wrempty		: OUT STD_LOGIC ;
			wrfull		: OUT STD_LOGIC ;
			wrusedw		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
		);
	end component;

	component fifo64 IS
	PORT
	(
		aclr		: IN STD_LOGIC  := '0';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdfull		: OUT STD_LOGIC ;
		wrempty		: OUT STD_LOGIC ;
		wrfull		: OUT STD_LOGIC ;
		wrusedw		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
	);
	END component fifo64;

	-- VGA sync
	--
	component vga_sync is
	port (
		-- vga clock
		clk 	: in std_logic;
		reset 	: in std_logic;
		hpos 	: out unsigned (15 downto 0);
		vpos 	: out unsigned (15 downto 0);
		-- communication with fifo
		fifo_empty 	: in std_logic;
		fifo_full 	: in std_logic;
		new_pixel 	: out std_logic;
		Rin, Gin, Bin : in std_logic_vector(7 downto 0);
		-- conduit signals
		Rout, Gout, Bout : out std_logic_vector(7 downto 0);
		hsync, vsync 	 : out std_logic;
		-- Timing parameters
		HBP		: in unsigned (15 downto 0);
		HFP		: in unsigned (15 downto 0);
		VBP		: in unsigned (15 downto 0);
		VFP		: in unsigned (15 downto 0);
		Hdata	: in unsigned (15 downto 0);
		Vdata	: in unsigned (15 downto 0);
		HS		: in unsigned (15 downto 0);
		VS		: in unsigned (15 downto 0)
	);
	end component vga_sync;

	-- Avalon master component
	--
	component Master_component is
	port
	(
		clk_50		: in std_logic;
		rst 		: in std_logic;
		--FIFO
		aclr 		: out std_logic;
		data_out 	: out std_logic_vector (31 downto 0);
		en_in 		: out std_logic;
		half 		: in std_logic;
		empty		: in std_logic;
		--Slave_component
		DisplayCom 	: in unsigned (15 downto 0);
		FBAdd 		: in unsigned (31 downto 0);
		FBLen 		: in unsigned (20 downto 0);
		DisplayStat : in unsigned (15 downto 0);
		-- Debug
		state_out	: out unsigned (2 downto 0);
		disp_com_out: out std_logic;
		is_idle		: out std_logic;
		--Avalon bus
		mm_paramm_address 		: out std_logic_vector (31 downto 0);
		mm_paramm_byteenable	: out std_logic_vector (3 downto 0); -- NOVI
		mm_paramm_read			: out std_logic;
		mm_paramm_readdata		: in std_logic_vector(31 downto 0);
		mm_paramm_readdatavalid : in std_logic;	
		mm_paramm_waitrequest	: in std_logic;	
		mm_paramm_burstcount	: out std_logic_vector(5 downto 0)
	);
	end component Master_component;

	-- Avalon slave component
	--
	component Slave_component is
	port
	(
		rst 						: in std_logic;
		clk_50 						: in std_logic;
		-- VGA_display
		VGA_VSync 					: in std_logic;
		HBP							: out unsigned (15 downto 0);
		HFP							: out unsigned (15 downto 0);
		VBP							: out unsigned (15 downto 0);
		VFP							: out unsigned (15 downto 0);
		Hdata						: out unsigned (15 downto 0);
		Vdata						: out unsigned (15 downto 0);
		Hsync						: out unsigned (15 downto 0);
		VSync						: out unsigned (15 downto 0);
		-- Master_component
		DisplayCom 					: out unsigned (15 downto 0);
		FBAdd 						: out unsigned (31 downto 0);
		FBLen 						: out unsigned (20 downto 0);
		DisplayStat 				: out unsigned (15 downto 0);
		--Avalon bus
		mm_params_address 		: in std_logic_vector(27 downto 0);
		mm_params_read				: in std_logic;
		mm_params_readdata 		: out std_logic_vector (31 downto 0);
		mm_params_write 			: in std_logic;
		mm_params_writedata 		: in std_logic_vector(31 downto 0);
		mm_params_waitrequest 	: out std_logic
	
	);
	end component Slave_component;

	-- VGA controller top
	--
	component VGA_controller is
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
	end component VGA_controller;
----------------------------
-- Testbench components
----------------------------
	
	-- Image generator
	--
	component image_gen is
	generic (
		H_DISPLAY: integer := 640;	-- visible pixels
		V_DISPLAY: integer := 480		-- visible pixels
	);
	port
	(
		-- inputs
		hpos : in integer range 0 to H_DISPLAY - 1;
		vpos : in integer range 0 to V_DISPLAY - 1;
		-- outputs
		Rout, Gout, Bout : out std_logic_vector(7 downto 0)
	);
	end component image_gen;
	
	-- Fifo input generator
	--
	component fifo_input_gen is
	generic (
		H_DISPLAY: integer := 640;	-- visible pixels
		V_DISPLAY: integer := 480		-- visible pixels
	);
	port
	(
		clk, rst : in std_logic;
		-- inputs
		fifo_empty, fifo_full, fifo_halffull : in std_logic;
		-- outputs
		fifo_write : out std_logic;
		fifo_clr   : out std_logic;
		Rout, Gout, Bout : out std_logic_vector(7 downto 0)
	);
	end component fifo_input_gen;
	
	component master_driver is
		port
		(
			clk_50		: in std_logic;
			rst 		: in std_logic;
			--Avalon master bus
			mm_paramm_address 		: in std_logic_vector (31 downto 0);
			mm_paramm_read			: in std_logic;
			mm_paramm_readdata		: out std_logic_vector(31 downto 0);
			mm_paramm_readdatavalid : out std_logic;	
			mm_paramm_waitrequest	: out std_logic;	
			mm_paramm_burstcount	: in std_logic_vector(5 downto 0)
		);
	end component master_driver;
end package vga_pkg;