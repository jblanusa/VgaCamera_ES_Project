-- 
-- @file: 	camera_controller.vhd
--
-- @brief: 	Camera controller top entity
--
-- @author:	Dario Korolija
--	@date:	December, 2016
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_controller is
	generic (
		NBITS_CAM		: natural := 8;
		NBITS_INT		: natural := 8
	);
	port (
		pixclk			: in  std_logic; 
		clk50			: in  std_logic;
		rst_n			: in  std_logic;
	-- From camera
		frame_valid		: in  std_logic;
		line_valid		: in  std_logic;
		data_in 		: in  std_logic_vector(NBITS_CAM-1 downto 0);
		cam_reset		: out std_logic;
	-- Avalon slave
		avs_Address		: in  std_logic_vector(3 downto 0);
		avs_ChipSelect	: in  std_logic;
		avs_Read		: in  std_logic;
		avs_Write		: in  std_logic;
		avs_WriteData	: in  std_logic_vector(31 downto 0);
		avs_ReadData	: out std_logic_vector(31 downto 0);
	-- Avalon master
		am_Addr			: out std_logic_vector(31 downto 0);
		am_Write		: out std_logic;
		am_DataWrite	: out std_logic_vector(31 downto 0);
		am_BurstCount	: out std_logic_vector(5 downto 0);
		am_WaitRequest	: in  std_logic
	);
end entity camera_controller;

architecture rtl of camera_controller is
	
	-- Sampler
	component camera_sampler is
		generic (
			NBITS_CAM		: natural;
			NBITS_INT		: natural );
		port (
			clk				: in  std_logic; 
			rst_n			: in  std_logic;
		-- From camera		
			f_valid_in		: in  std_logic;	
			l_valid_in		: in  std_logic;
			data_in			: in  std_logic_vector(NBITS_CAM-1 downto 0);
		-- Camera slave
			cmd_start		: in  std_logic;
			cmd_snapshot	: in  std_logic;
			conf_f_height	: in  std_logic_vector(15 downto 0);
			conf_f_width	: in  std_logic_vector(15 downto 0);
			sta_idle		: out std_logic;
			sta_error		: out std_logic;
		-- To FIFO
			data_out		: out std_logic_vector(3*NBITS_INT-1 downto 0);
			valid_out		: out std_logic );
	end component camera_sampler;
	
	-- Avalon slave
	component camera_slave is
		port (
			clk					: in  std_logic;
			rst_n				: in  std_logic;	
		-- Avalon signals
			avs_Address			: in  std_logic_vector(3 downto 0);
			avs_ChipSelect		: in  std_logic;
			avs_Read			: in  std_logic;
			avs_Write			: in  std_logic;
			avs_WriteData		: in  std_logic_vector(31 downto 0);
			avs_ReadData		: out std_logic_vector(31 downto 0);	
		-- Camera master
			camm_length			: out std_logic_vector(31 downto 0);
			camm_dest			: out std_logic_vector(31 downto 0);
			camm_burst			: out std_logic_vector(5 downto 0);
			camm_debug			: in  std_logic_vector(31 downto 0);		
		-- Camera sampler
			cams_idle			: in  std_logic;
			cams_error			: in  std_logic;
			cams_start			: out std_logic;
			cams_snapshot		: out std_logic;
			conf_f_height		: out std_logic_vector(15 downto 0);
			conf_f_width		: out std_logic_vector(15 downto 0) );
	end component camera_slave;
	
	-- Avalon master
	component camera_master is
		port (
			clk				: in  std_logic;
			rst_n			: in  std_logic;
		-- Camera slave
			cmd_start		: in  std_logic;
			AcqLength		: in  std_logic_vector(31 downto 0);
			AcqAddress		: in  std_logic_vector(31 downto 0);
			AcqBurst		: in  std_logic_vector(5 downto 0);
			camm_debug		: out std_logic_vector(31 downto 0);
		-- FIFO main
			rd_ready		: in  std_logic_vector(5 downto 0);
			rd_fifo			: out std_logic;
			data_in			: in  std_logic_vector(23 downto 0);
			aclr			: out std_logic;
		-- Avalon Master
			AM_Addr			: out std_logic_vector(31 downto 0);
			AM_Write		: out std_logic;
			AM_DataWrite	: out std_logic_vector(31 downto 0);
			AM_BurstCount	: out std_logic_vector(5 downto 0);
			AM_WaitRequest	: in  std_logic );
	end component camera_master;
	
	-- FIFO - main
	component FIFO_two_clock is
		PORT(
			data		: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
			rdclk		: IN STD_LOGIC ;
			rdreq		: IN STD_LOGIC ;
			wrclk		: IN STD_LOGIC ;
			wrreq		: IN STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
			rdempty		: OUT STD_LOGIC ;
			rdusedw		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			wrfull		: OUT STD_LOGIC );
	end component FIFO_two_clock;
	
	-- Signals
	
	-- Sampler
	signal  sta_idle_sampler_slave, 
			sta_error_sampler_slave								: std_logic;
	signal  valid_out_sampler_fifo								: std_logic;
	signal  data_sampler_fifo									: std_logic_vector(3*NBITS_INT-1 downto 0);
	
	-- Slave
	signal 	cmd_start_slave_sampler,					
			cmd_snapshot_slave_sampler							: std_logic;
	signal	conf_f_height_slave_sampler,
			conf_f_width_slave_sampler							: std_logic_vector(15 downto 0);
	signal  camm_length_slave_master,
			camm_dest_slave_master								: std_logic_vector(31 downto 0);
	signal	camm_burst_slave_master								: std_logic_vector(5 downto 0);
			
	-- Master 
	signal  camm_debug_master_slave								: std_logic_vector(31 downto 0);
	signal  rd_fifo_master_fifo,
			aclr_master_fifo									: std_logic; 
			
	-- FIFO
	signal  data_fifo_master									: std_logic_vector(3*NBITS_INT-1 downto 0);
	signal  rd_ready_fifo_master								: std_logic_vector(5 downto 0);
	signal  empty_fifo,
			full_fifo											: std_logic;
	
begin
	
	SMPLR : camera_sampler 
	generic map(
		NBITS_CAM => NBITS_CAM,
		NBITS_INT => NBITS_INT )
	port map (
		clk				=> pixclk, 
		rst_n			=> rst_n,
		f_valid_in		=> frame_valid,	
		l_valid_in		=> line_valid,
		data_in			=> data_in,
		cmd_start		=> cmd_start_slave_sampler,
		cmd_snapshot	=> cmd_snapshot_slave_sampler,
		conf_f_height	=> conf_f_height_slave_sampler,
		conf_f_width	=> conf_f_width_slave_sampler,
		sta_idle		=> sta_idle_sampler_slave,
		sta_error		=> sta_error_sampler_slave,
		data_out		=> data_sampler_fifo,
		valid_out		=> valid_out_sampler_fifo );
		
	SLV : camera_slave
	port map (
		clk					=> clk50,
		rst_n				=> rst_n,	
		avs_Address			=> avs_Address,
		avs_ChipSelect		=> avs_ChipSelect,
		avs_Read			=> avs_Read,
		avs_Write			=> avs_Write,
		avs_WriteData		=> avs_WriteData,
		avs_ReadData		=> avs_ReadData,	
		camm_length			=> camm_length_slave_master,
		camm_dest			=> camm_dest_slave_master,
		camm_burst			=> camm_burst_slave_master,
		camm_debug			=> camm_debug_master_slave,		
		cams_idle			=> sta_idle_sampler_slave,
		cams_error			=> sta_error_sampler_slave,
		cams_start			=> cmd_start_slave_sampler,
		cams_snapshot		=> cmd_snapshot_slave_sampler,
		conf_f_height		=> conf_f_height_slave_sampler,
		conf_f_width		=> conf_f_width_slave_sampler );
		
	MSTR : camera_master
	port map (
		clk					=> clk50,
		rst_n				=> rst_n,
		cmd_start			=> cmd_start_slave_sampler,
		AcqLength			=> camm_length_slave_master,
		AcqAddress			=> camm_dest_slave_master,
		AcqBurst			=> camm_burst_slave_master,
		camm_debug			=> camm_debug_master_slave,
		rd_ready			=> rd_ready_fifo_master,
		rd_fifo				=> rd_fifo_master_fifo,
		data_in				=> data_fifo_master,
		aclr				=> aclr_master_fifo,
		AM_Addr				=> am_Addr,
		AM_Write			=> am_Write,
		AM_DataWrite		=> am_DataWrite,
		AM_BurstCount		=> am_BurstCount,
		AM_WaitRequest		=> am_WaitRequest );
		
	FIFO : FIFO_two_clock PORT MAP (
		data				=> data_sampler_fifo,
		rdclk				=> clk50,
		rdreq				=> rd_fifo_master_fifo,
		wrclk				=> pixclk,
		wrreq				=> valid_out_sampler_fifo,
		q					=> data_fifo_master,
		rdempty				=> empty_fifo,
		rdusedw				=> rd_ready_fifo_master,
		wrfull				=> full_fifo );
		
	cam_reset <= rst_n;
	
		
end architecture rtl;