library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Master_component is
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
end Master_component;


architecture rtl of Master_component is
	constant BURST_SIZE : integer := 32;
	constant ADDR_INC   : integer := 4;
	
	constant ZERO		: unsigned(5 downto 0) := (others => '0');
	type states is (ST_INIT, ST_INITREAD1, ST_INITREAD2, ST_RUN, ST_RUNREAD1, ST_RUNREAD2);
	
	signal state_reg, state_next : states;
	signal current_address_reg, current_address_next : unsigned(31 downto 0);
	signal counter_reg, counter_next: unsigned(5 downto 0);
	signal read_burst: std_logic;
begin
	mm_paramm_read <= read_burst;
	mm_paramm_byteenable <= "1111";
	mm_paramm_burstcount <= "100000";
	mm_paramm_address <= std_logic_vector(current_address_reg);
	data_out <= mm_paramm_readdata;
	
	state_out <= to_unsigned(states'pos(state_reg), 3);
	disp_com_out <= DisplayCom(0);
	
	-- Registers
	--
	REG: process (clk_50, rst)
	begin
		if rst = '1' then
			state_reg <= ST_INIT;
			current_address_reg <= FBAdd;
			counter_reg <= ZERO;
		elsif rising_edge(clk_50) then
			state_reg <= state_next;
			current_address_reg <= current_address_next;
			counter_reg <= counter_next;
		end if;
	end process REG;
	
	-- Next State Logic
	--
	NSL: process (state_reg, DisplayCom, counter_reg, half, read_burst, mm_paramm_waitrequest, empty)
	begin
		state_next <= state_reg; --avoid latches
		case state_reg is
			when ST_INIT => 
				if DisplayCom(0) = '1' then
					state_next <= ST_INITREAD1;
				end if;
			when ST_INITREAD1 => 
				if DisplayCom(0) = '0' then
					state_next <= ST_INIT;
				elsif read_burst = '1' and mm_paramm_waitrequest = '0' then
					state_next <= ST_INITREAD2;
				end if;
			when ST_INITREAD2 => 
				if DisplayCom(0) = '0'  then
					state_next <= ST_INIT;
				elsif counter_reg = BURST_SIZE - 1 then --or counter_reg = 2 * BURST_SIZE - 1 or counter_reg = 3 * BURST_SIZE - 1 then
					state_next <= ST_INITREAD1;
				elsif counter_reg = 2 * BURST_SIZE - 1 then
					state_next <= ST_RUN;			
				end if;
			when ST_RUN =>
				if DisplayCom(0) = '0' or empty = '1' then
					state_next <= ST_INIT;
				elsif half = '1' then 
					state_next <= ST_RUNREAD1;
				end if;
			when ST_RUNREAD1 =>
				if DisplayCom(0) = '0' or empty = '1'  then
					state_next <= ST_INIT;
				elsif read_burst = '1' and mm_paramm_waitrequest = '0' then
					state_next <= ST_RUNREAD2;
				end if;
			when ST_RUNREAD2 =>
				if DisplayCom(0) = '0' or empty = '1'  then
					state_next <= ST_INIT;
				elsif counter_reg = BURST_SIZE - 1 then
					state_next <= ST_RUN;
				end if;
		end case;
	end process NSL;
	
	-- Datapath
	--
	DP: process (state_reg, counter_reg, current_address_reg, mm_paramm_readdatavalid)
	begin
		current_address_next <= current_address_reg;
		counter_next <= counter_reg;
		read_burst <= '0';
		aclr  <= '0';
		en_in <= '0';
		is_idle <= '0';
		case state_reg is
			when ST_INIT =>
				is_idle <= '1';
				aclr <= '1';
				current_address_next <= FBAdd;
				counter_next <= ZERO;
			when ST_INITREAD1 =>
				read_burst <= '1';
			when ST_INITREAD2 =>
				en_in <= mm_paramm_readdatavalid;
				if mm_paramm_readdatavalid = '1' then
					counter_next <= counter_reg + 1;
					current_address_next <= current_address_reg + ADDR_INC;
				end if;
			when ST_RUN =>
				counter_next <= ZERO;
				if current_address_reg = FBAdd + FBLen*ADDR_INC then
					current_address_next <= FBAdd;
				end if;
			when ST_RUNREAD1 =>
				read_burst <= '1';
				counter_next <= ZERO;
			when ST_RUNREAD2 =>
				en_in <= mm_paramm_readdatavalid;
				if mm_paramm_readdatavalid = '1' then
					counter_next <= counter_reg + 1;
					current_address_next <= current_address_reg + ADDR_INC;
				end if;
		end case;
	end process DP;
	
end rtl;
