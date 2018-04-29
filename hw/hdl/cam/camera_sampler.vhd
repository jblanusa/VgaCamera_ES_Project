-- 
-- @file: 	camera_sampler.vhd
--
-- @brief: 	Camera sampler entity
--
-- @author:	Dario Korolija
--	@date:	December, 2016
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_sampler is
	generic (
		NBITS_CAM		: natural := 8;
		NBITS_INT		: natural := 8
	);
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
		valid_out		: out std_logic
	);
end entity camera_sampler;

architecture rtl of camera_sampler is
	
	-- Synchronizer
	component camera_sampler_sync is
		generic (
			NBITS_CAM		: natural;
			NBITS_INT		: natural );
		port (
			clk				: in std_logic;
			rst_n			: in std_logic;
		-- From camera		
			f_valid_in		: in std_logic;	
			l_valid_in		: in std_logic;
			data_in			: in std_logic_vector(NBITS_CAM-1 downto 0);
		-- To input
			l_valid_out		: out std_logic;
			f_valid_out		: out std_logic;
			data_out		: out std_logic_vector(NBITS_INT-1 downto 0) );
	end component camera_sampler_sync;
	
	-- FSM
	component camera_sampler_fsm is
		generic (
			NBITS_INT		: natural );
		port (
			clk				: in  std_logic;
			rst_n			: in  std_logic;
		-- Camera sync
			f_valid_in		: in  std_logic;
			l_valid_in		: in  std_logic;
			data_in			: in  std_logic_vector(NBITS_INT-1 downto 0);
		-- Camera converter	
			cmd_scan_row_1	: out std_logic;
			cmd_scan_row_2	: out std_logic;
			data_out		: out std_logic_vector(NBITS_INT-1 downto 0);
			cmd_clear		: out std_logic;
		-- Camera slave
			cmd_start		: in  std_logic;
			cmd_snapshot	: in  std_logic;
			conf_f_height	: in  std_logic_vector(15 downto 0);
			sta_idle		: out std_logic;
			sta_error		: out std_logic );
	end component camera_sampler_fsm;
	
	-- Converter
	component camera_sampler_converter is
		generic (
			NBITS_INT		: natural );
		port (
			clk				: in  std_logic;
			rst_n			: in  std_logic;
		-- Camera input
			cmd_scan_row_1	: in  std_logic;
			cmd_scan_row_2	: in  std_logic;
			data_in			: in  std_logic_vector(NBITS_INT-1 downto 0);
			cmd_clear		: in  std_logic;
		-- FIFO main
			data_out		: out std_logic_vector(3*NBITS_INT-1 downto 0);
			valid_out		: out std_logic;
		-- Camera slave
			conf_f_width	: in  std_logic_vector(15 downto 0) );
	end component camera_sampler_converter;
	
	-- Signals
	
	-- Synchronizer
	signal l_valid_sync_fsm, f_valid_sync_fsm			: std_logic;
	signal data_sync_fsm								: std_logic_vector(NBITS_INT-1 downto 0);
	
	-- FSM
	signal cmd_scan_row_1_fsm_conv, 
		   cmd_scan_row_2_fsm_conv						: std_logic;
	signal data_fsm_conv								: std_logic_vector(NBITS_INT-1 downto 0);	
	signal cmd_clear_fsm_conv							: std_logic;   
		
	
begin
	
	-- Sync
	SYNC : camera_sampler_sync 
	generic map(
		NBITS_CAM => NBITS_CAM,
		NBITS_INT => NBITS_INT )	
	port map (
		clk				=> clk,
		rst_n			=> rst_n,
		f_valid_in		=> f_valid_in,
		l_valid_in		=> l_valid_in,
		data_in			=> data_in,
		l_valid_out		=> l_valid_sync_fsm,
		f_valid_out		=> f_valid_sync_fsm,
		data_out		=> data_sync_fsm );
		
	-- FSM
	FSM : camera_sampler_fsm 
	generic map(
		NBITS_INT => NBITS_INT )	
	port map (
		clk				=> clk,
		rst_n			=> rst_n,
		f_valid_in		=> f_valid_sync_fsm,
		l_valid_in		=> l_valid_sync_fsm,
		data_in			=> data_sync_fsm,	
		cmd_scan_row_1	=> cmd_scan_row_1_fsm_conv,
		cmd_scan_row_2	=> cmd_scan_row_2_fsm_conv,
		data_out		=> data_fsm_conv,
		cmd_clear		=> cmd_clear_fsm_conv,
		cmd_start		=> cmd_start,
		cmd_snapshot	=> cmd_snapshot,
		conf_f_height	=> conf_f_height,
		sta_idle		=> sta_idle,
		sta_error		=> sta_error );
		
	CNV : camera_sampler_converter 
	generic map(
		NBITS_INT => NBITS_INT )
	port map (
		clk				=> clk,
		rst_n			=> rst_n,
		cmd_scan_row_1	=> cmd_scan_row_1_fsm_conv,
		cmd_scan_row_2	=> cmd_scan_row_2_fsm_conv,
		data_in			=> data_fsm_conv,
		cmd_clear		=> cmd_clear_fsm_conv,
		data_out		=> data_out,
		valid_out		=> valid_out,
		conf_f_width	=> conf_f_width );
	
end architecture rtl;