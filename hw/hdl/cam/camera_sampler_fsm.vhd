--
-- @file: 	camera_sampler_fsm.vhd
--
-- @brief:	FSM which controls the sampler unit.
-- @author: Dario Korolija
-- @date:	December, 2016.
-- 
--
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_sampler_fsm is
	generic (
		NBITS_INT		: natural := 8
	);
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
		sta_error		: out std_logic
	);
end entity camera_sampler_fsm;

architecture rtl of camera_sampler_fsm is
	
	-- FSM
	type state_type is (ST_IDLE, ST_WAIT_F_END, ST_WAIT_F_NEW, ST_R_ROW_1, ST_WAIT_L_NEW_1,
		ST_R_ROW_2, ST_WAIT_L_NEW_2, ST_BLANK, ST_SNAPSHOT);
	signal state_reg, state_next 	: state_type;
	
	-- Registers
	signal reg_d, reg_d_next		: std_logic_vector(NBITS_INT-1 downto 0);
	signal l_cnt_reg, l_cnt_next	: unsigned(15 downto 0);
	signal err_reg, err_next		: std_logic;
	
	-- Datapath
	signal d_cnt					: std_logic;
	
begin
	
	REG : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			state_reg 	<= ST_IDLE;
			reg_d		<= (others => '0');	
			l_cnt_reg	<= (others => '0');
			err_reg	<= '0';
		elsif rising_edge(clk) then
			state_reg 	<= state_next;
			reg_d		<= reg_d_next;
			l_cnt_reg 	<= l_cnt_next;
			err_reg		<= err_next;
		end if;
	end process REG;
	
	NSL : process (state_reg, cmd_start, f_valid_in, l_valid_in, d_cnt, cmd_snapshot) is
	begin
		state_next <= state_reg;
		case state_reg is			
			when ST_IDLE =>
				if cmd_start = '1' then
					if f_valid_in = '1' then
						state_next <= ST_WAIT_F_END;
					elsif f_valid_in = '0' then
						state_next <= ST_WAIT_F_NEW;
					end if;	
				end if;			
			when ST_WAIT_F_END =>
				if cmd_start = '0' then
					state_next <= ST_IDLE;
				elsif f_valid_in = '0' then
					state_next <= ST_WAIT_F_NEW;
				end if;			
			when ST_WAIT_F_NEW =>
				if cmd_start = '0' then 
					state_next <= ST_IDLE;
				elsif f_valid_in = '1' then
					state_next <= ST_WAIT_L_NEW_1;
				end if;				
			when ST_WAIT_L_NEW_1 =>
				if f_valid_in = '1' then
					if l_valid_in = '1' then
						state_next <= ST_R_ROW_1;
					end if;
				elsif f_valid_in = '0' then
					if cmd_start = '1' then
						if cmd_snapshot = '1' then
							state_next <= ST_SNAPSHOT;
						else
							state_next <= ST_WAIT_F_NEW;
						end if;
					else
						state_next <= ST_IDLE;
					end if;
				end if;				
			when ST_R_ROW_1 =>
				if l_valid_in = '0' then
					state_next <= ST_WAIT_L_NEW_2;
				end if;					
			when ST_WAIT_L_NEW_2 =>
				if l_valid_in = '1' then
					state_next <= ST_R_ROW_2;
				end if;
			when ST_R_ROW_2 =>
				if l_valid_in = '0' then
					if d_cnt = '1' then
						state_next <= ST_BLANK;
					else
						state_next <= ST_WAIT_L_NEW_1;
					end if;	
				end if;			
			when ST_BLANK =>
				if f_valid_in = '0' then
					if cmd_start = '1' then
						if cmd_snapshot = '1' then
							state_next <= ST_SNAPSHOT;
						else
							state_next <= ST_WAIT_F_NEW;
						end if;
					else
						state_next <= ST_IDLE;
					end if;
				end if;	
			when ST_SNAPSHOT =>
				if cmd_start = '0' then
					state_next <= ST_IDLE;
				elsif cmd_snapshot = '0' then
					state_next <= ST_IDLE;
				end if;		
		end case;
	end process NSL;
	
	DP : process (state_reg, l_cnt_reg, err_reg, f_valid_in, l_valid_in) is
	begin
		l_cnt_next 	<= l_cnt_reg;
		err_next	<= err_reg;
		case state_reg is
			when ST_IDLE =>
				l_cnt_next 	<= (others => '0');
				err_next	<= '0';
			when ST_WAIT_F_NEW => 
				l_cnt_next	<= (others => '0');
			when ST_WAIT_L_NEW_1 =>
				if f_valid_in = '1' then
					if l_valid_in = '1' then
						l_cnt_next  <= l_cnt_reg + 1;
					end if;
				end if;
			when ST_R_ROW_1 =>
				if f_valid_in = '0' then
					err_next <= '1';
				end if;
			when ST_R_ROW_2 =>
				if f_valid_in = '0' then
					err_next <= '1';
				end if;
			when ST_WAIT_L_NEW_2 =>
				if f_valid_in = '0' then
					err_next <= '1';
				end if;
			when others => null;
		end case;
	end process DP;
	
	-- Datapath
	reg_d_next 	<= data_in;
	d_cnt		<= '1' when l_cnt_reg = unsigned(conf_f_height) else '0';
	
	-- Outputs	
	cmd_scan_row_1	<= '1' when state_reg = ST_R_ROW_1 	else '0';
	cmd_scan_row_2	<= '1' when state_reg = ST_R_ROW_2  else '0';
	cmd_clear		<= '1' when state_reg = ST_IDLE		else '0';
	data_out		<= reg_d;
	sta_idle		<= '1' when state_reg = ST_IDLE 	else '0';
	sta_error		<= err_reg;
	
end architecture rtl;