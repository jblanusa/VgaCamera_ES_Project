--
-- @file: 	camera_master.vhd
--
-- @brief:	Avalon master used for burst write.
-- 
-- @author: Dario Korolija
-- @date:	December, 2016.
-- 
	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_master is
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
		AM_WaitRequest	: in  std_logic
	);
end entity camera_master;

architecture rtl of camera_master is
	
	-- FSM
	type state_type is (ST_IDLE, ST_WAIT_DATA, ST_BURST_WRITE);
	signal state_reg, state_next		: state_type;
	
	-- Registers
	signal cnt_bur_reg, cnt_bur_next			: unsigned(5 downto 0);
	signal cnt_add_reg, cnt_add_next			: unsigned(31 downto 0);
	signal debug_reg, debug_next				: std_logic_vector(31 downto 0);
	
	-- Status
	signal d_cnt								: std_logic;
	
begin

	REG : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			state_reg	<= ST_IDLE;
			cnt_bur_reg	<= (others => '0');
			cnt_add_reg <= unsigned(AcqAddress);
			debug_reg	<= (others => '0');
		elsif rising_edge(clk) then
			state_reg	<= state_next;
			cnt_bur_reg	<= cnt_bur_next;
			cnt_add_reg <= cnt_add_next;
			debug_reg	<= debug_next;
		end if;
	end process REG;
	
	NSL : process (state_reg, cmd_start, rd_ready, d_cnt, AM_WaitRequest) is
	begin
		state_next	<= state_reg;
		case state_reg is
			when ST_IDLE =>
				if cmd_start = '1' then
					state_next	<= ST_WAIT_DATA;
				end if;
			when ST_WAIT_DATA =>
				if cmd_start = '0' then
					state_next 	<= ST_IDLE;
				elsif rd_ready = AcqBurst then
					state_next 	<= ST_BURST_WRITE;
				end if;
			when ST_BURST_WRITE =>
				if AM_WaitRequest = '0' then 
					if d_cnt = '1' then
						if rd_ready = AcqBurst then
							state_next 	<= ST_BURST_WRITE;
						else
							state_next	<= ST_WAIT_DATA;
						end if;
					end if;
				end if;
		end case;
	end process NSL;
	
	DP : process (state_reg, cnt_add_reg, cnt_bur_reg, AM_WaitRequest) is
	begin
		cnt_bur_next 	<= cnt_bur_reg;
		cnt_add_next	<= cnt_add_reg;
		case state_reg is 
			when ST_IDLE => 
				cnt_add_next	<= unsigned(AcqAddress);
				cnt_bur_next	<= (others => '0');
			when ST_WAIT_DATA =>	
				if cnt_add_reg = unsigned(AcqAddress) + unsigned(AcqLength) - 4 then
						cnt_add_next <= unsigned(AcqAddress);
				end if;
			when ST_BURST_WRITE => 
				if AM_WaitRequest = '0'  then
					if cnt_bur_reg = unsigned(AcqBurst)-1  then
						cnt_bur_next <= (others => '0');
					else
						cnt_bur_next <= cnt_bur_reg + 1;
					end if;
					if cnt_add_reg = unsigned(AcqAddress) + unsigned(AcqLength) - 4 then
						cnt_add_next <= unsigned(AcqAddress);
					else
						cnt_add_next <= cnt_add_reg + 4;
					end if;
				end if;	
		end case;
	end process DP;
	
	DBG : process (debug_reg, data_in) is
	begin
		debug_next <= debug_reg;
		if data_in /= X"000000" then
			debug_next(23 downto 0) <= data_in;
			debug_next(31 downto 24) <= (others => '0');
		end if;
	end process DBG;

	-- Datapath
	d_cnt			<= '1' when cnt_bur_reg = unsigned(AcqBurst)-1 else '0';
	-- Outputs
	aclr			<= '1' when state_reg = ST_IDLE else '0';
	rd_fifo		<= '1' when state_reg = ST_BURST_WRITE and AM_WaitRequest = '0' else '0';
	AM_Addr		<= std_logic_vector(cnt_add_reg);
	AM_Write		<= '1' when state_reg = ST_BURST_WRITE else '0';
	AM_DataWrite(31 downto 24) 	<= (others => '0');
	AM_DataWrite(23 downto 0)	<= data_in;
	AM_BurstCount	<= AcqBurst;
	camm_debug		<= debug_reg;
	
end architecture rtl; 
