-- 
-- @file 	camera_slave_regmap.vhd
--
-- @brief: 	Avalon slave register map
--
-- @author:	Dario Korolija
--	@date:	December, 2016
--

library ieee;
use ieee.std_logic_1164.all;

package register_mapping_camera_slave is
	
	constant CAM_S_COMM_ADDR		: std_logic_vector(3 downto 0) := X"0";
	constant CAM_S_CONS_ADDR		: std_logic_vector(3 downto 0) := X"1";
	constant CAM_S_CONB_ADDR	 	: std_logic_vector(3 downto 0) := X"2";
	constant CAM_S_DEST_ADDR		: std_logic_vector(3 downto 0) := X"3";
	constant CAM_S_LENG_ADDR		: std_logic_vector(3 downto 0) := X"4";
	constant CAM_S_STAT_ADDR		: std_logic_vector(3 downto 0) := X"5";  
	constant CAM_S_DEBU_ADDR		: std_logic_vector(3 downto 0) := X"6";

end package register_mapping_camera_slave;