--
-- @file: 	camera_sampler_sync.vhd
--
-- @brief:	Synchronizes data coming into the controller. 
--
-- @author: Dario Korolija
-- @date:	December, 2016. 
--

library ieee;
use ieee.std_logic_1164.all;

entity camera_sampler_sync is
	generic (
		NBITS_CAM		: natural := 8;
		NBITS_INT		: natural := 8
	);
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
		data_out		: out std_logic_vector(NBITS_INT-1 downto 0)
	);
end entity camera_sampler_sync;

architecture rtl of camera_sampler_sync is

	signal f_reg_in, f_reg_in_next			: std_logic;
	signal l_reg_in, l_reg_in_next			: std_logic;
	signal data_reg_in, data_reg_in_next	: std_logic_vector(NBITS_INT-1 downto 0);
	
	signal f_reg_out, f_reg_out_next		: std_logic;
	signal l_reg_out, l_reg_out_next		: std_logic;
	signal data_reg_out, data_reg_out_next	: std_logic_vector(NBITS_INT-1 downto 0);

begin
	
	REG : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			f_reg_in		<= '0';
			l_reg_in 		<= '0';
			data_reg_in 	<= (others => '0');
			f_reg_out		<= '0';
			l_reg_out 		<= '0';
			data_reg_out 	<= (others => '0');
		elsif falling_edge(clk) then
			f_reg_in 		<= f_reg_in_next;
			l_reg_in		<= l_reg_in_next;
			data_reg_in		<= data_reg_in_next;
		elsif rising_edge(clk) then
			f_reg_out 		<= f_reg_out_next;
			l_reg_out		<= l_reg_out_next;
			data_reg_out	<= data_reg_out_next;
		end if;
	end process REG;
	
	-- Datapath
	f_reg_in_next 		<= f_valid_in;
	l_reg_in_next 		<= l_valid_in;
	data_reg_in_next 	<= data_in(NBITS_CAM-1 downto NBITS_CAM-NBITS_INT);
	
	f_reg_out_next		<= f_reg_in;
	l_reg_out_next		<= l_reg_in;
	data_reg_out_next	<= data_reg_in;
	
	-- Outputs
	f_valid_out 	<= f_reg_out;
	l_valid_out		<= l_reg_out;
	data_out		<= data_reg_out;
	
end architecture rtl;