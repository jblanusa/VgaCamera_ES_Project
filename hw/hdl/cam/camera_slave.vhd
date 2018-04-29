-- 
-- @file: 	camera_slave.vhd
--
-- @brief: 	Avalon slave configuration unit
--
-- @author:	Dario Korolija
--	@date:	December, 2016
--

library ieee;
use ieee.std_logic_1164.all;

use work.register_mapping_camera_slave.all;

entity camera_slave	is
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
		conf_f_width		: out std_logic_vector(15 downto 0)
	);
end entity camera_slave;

architecture rtl of camera_slave is
	
	-- Registers
	signal conf_reg_frame	: std_logic_vector(31 downto 0);
	signal conf_reg_burst	: std_logic_vector(5 downto 0);
	signal dest_reg			: std_logic_vector(31 downto 0);
	signal leng_reg			: std_logic_vector(31 downto 0);
	signal comm_reg			: std_logic_vector(7 downto 0);
	signal stat_reg			: std_logic_vector(7 downto 0);
	signal debug_reg		: std_logic_vector(31 downto 0);

begin

	-- Write 
	WR_REG : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			comm_reg 		<= X"00";
			conf_reg_frame	<= X"028001E0";
			conf_reg_burst	<= "000100";
			dest_reg 		<= (others => '0');
			leng_reg 		<= X"0012C000";
			stat_reg 		<= (others => '0');
			debug_reg		<= (others => '0');
		elsif rising_edge(clk) then
			if avs_chipSelect = '1' and avs_Write = '1' then
				case avs_Address is			
						when CAM_S_COMM_ADDR => 
							comm_reg <= avs_WriteData(7 downto 0);
						when CAM_S_CONS_ADDR => 
							if cams_idle = '1' then
								conf_reg_frame <= avs_WriteData;
							end if;
						when CAM_S_CONB_ADDR =>
							if cams_idle = '1' then
								conf_reg_burst <= avs_WriteData(5 downto 0);
							end if;
						when CAM_S_DEST_ADDR => 
							if cams_idle = '1' then	
								dest_reg <= avs_WriteData;
							end if;
						when CAM_S_LENG_ADDR => 
							if cams_idle = '1' then
								leng_reg <= avs_WriteData;
							end if;
						when others => null;
				end case;
			end if;
			stat_reg(3) <= cams_error;
			stat_reg(2) <= cams_idle;
			stat_reg(1) <= comm_reg(1);
			stat_reg(0) <= comm_reg(0);
			debug_reg	<= camm_debug;
		end if;
	end process WR_REG;
	
	-- Read
	RD_REG : process (clk) is
	begin
		if rising_edge(clk) then
			if avs_ChipSelect = '1' and avs_Read = '1' then
				avs_ReadData <= (others => '0');
				case avs_Address is
					when CAM_S_COMM_ADDR => avs_ReadData(7 downto 0) <= comm_reg;
					when CAM_S_STAT_ADDR => avs_ReadData(7 downto 0) <= stat_reg;
					when CAM_S_CONS_ADDR => avs_ReadData(31 downto 0) <= conf_reg_frame;
					when CAM_S_CONB_ADDR => avs_ReadData(5 downto 0) <= conf_reg_burst;
					when CAM_S_DEST_ADDR => avs_ReadData(31 downto 0) <= dest_reg;
					when CAM_S_LENG_ADDR => avs_ReadData(31 downto 0) <= leng_reg;
					when CAM_S_DEBU_ADDR => avs_ReadData(31 downto 0) <= debug_reg;
					when others => null;
				end case;
			end if;
		end if;
	end process RD_REG;
	
	conf_f_height	<= conf_reg_frame(15 downto 0);
	conf_f_width 	<= conf_reg_frame(31 downto 16);
	cams_start		<= comm_reg(0);
	cams_snapshot	<= comm_reg(1);	
	camm_burst		<= conf_reg_burst;
	camm_length		<= leng_reg;
	camm_dest		<= dest_reg;

end architecture rtl;