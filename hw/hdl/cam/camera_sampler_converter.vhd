--
-- @file: 	camera_sampler_converter.vhd
--
-- @brief:	Bayer to RGB conversion.
-- @author: Dario Korolija
-- @date:	December, 2016.
-- 
--
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity camera_sampler_converter is
	generic (
		NBITS_INT		: natural := 8
	);
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
		conf_f_width	: in  std_logic_vector(15 downto 0)
	);
end entity camera_sampler_converter;

architecture rtl of camera_sampler_converter is

	component FIFO_one_clock is
		PORT (
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			rdreq		: IN STD_LOGIC ;
			sclr		: IN STD_LOGIC ;
			wrreq		: IN STD_LOGIC ;
			empty		: OUT STD_LOGIC ;
			full		: OUT STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0) );
	end component FIFO_one_clock;

	-- FIFO signals
	signal clr_fifo		: std_logic;
	signal empty_fifo	: std_logic;
	signal full_fifo	: std_logic;
	signal data_fifo	: std_logic_vector(NBITS_INT-1 downto 0);
	
	-- Registers
	signal g1_reg, g1_next 		: std_logic_vector(NBITS_INT downto 0);
	signal g2_reg, g2_next		: std_logic_vector(NBITS_INT downto 0);
	signal r_reg, r_next		: std_logic_vector(NBITS_INT-1 downto 0);
	signal b_reg, b_next		: std_logic_vector(NBITS_INT-1 downto 0);
	
	signal r_out, r_out_next	: std_logic_vector(NBITS_INT-1 downto 0);
	signal g_out, g_out_next	: std_logic_vector(NBITS_INT-1 downto 0);
	signal b_out, b_out_next	: std_logic_vector(NBITS_INT-1 downto 0);
	
	signal data_reg, data_next	: std_logic_vector(NBITS_INT-1 downto 0);
	signal v_reg, v_next		: std_logic;
	signal vo_reg, vo_next		: std_logic;
	
	signal p_cnt_reg, p_cnt_next: unsigned(15 downto 0);
	
	-- FSM
	type state_type is (ST_IDLE, ST_WR_1, ST_WR_2, ST_BLANK, ST_CLR);
	signal state_reg, state_next	: state_type;
	
	-- Datapath
	signal g_added				: std_logic_vector(NBITS_INT downto 0);
	signal d_cnt				: std_logic;
	
begin
	
	FIFO : FIFO_one_clock PORT MAP (
		clock	 		=> clk,
		data			=> data_in,
		rdreq	 		=> cmd_scan_row_2,
		sclr	 		=> clr_fifo,
		wrreq	 		=> cmd_scan_row_1,
		empty	 		=> empty_fifo,
		full	 		=> full_fifo,
		q	 			=> data_fifo
	);
	
	REG : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			state_reg 	<= ST_IDLE;
			data_reg 	<= (others => '0');
			v_reg		<= '0';
			vo_reg		<= '0';
			p_cnt_reg	<= (others => '0');
		elsif rising_edge(clk) then
			state_reg 	<= state_next;
			data_reg 	<= data_next;
			v_reg		<= v_next;
			vo_reg		<= vo_next;
			p_cnt_reg	<= p_cnt_next;
		end if;
	end process REG;
	
	WR1_REG : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			g1_reg 	<= (others => '0');
			b_reg	<= (others => '0');
		elsif rising_edge(clk) then
			if state_reg = ST_WR_1 then
				g1_reg 	<= g1_next;
				b_reg	<= b_next;
			end if;
		end if;
	end process WR1_REG;
	
	WR2_REG : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			g2_reg 	<= (others => '0');
			r_reg	<= (others => '0');
		elsif rising_edge(clk) then
			if state_reg = ST_WR_2 then
				g2_reg 	<= g2_next;
				r_reg	<= r_next;
			end if;
		end if;
	end process WR2_REG;
	
	OUT_REG : process (clk, rst_n) is
	begin
		if rst_n = '0' then
			r_out 	<= (others => '0');
			g_out	<= (others => '0');
			b_out	<= (others => '0');
		elsif rising_edge(clk) then
			if v_reg = '1' then
				r_out	<= r_out_next;
				g_out	<= g_out_next;
				b_out	<= b_out_next;
			end if;
		end if;
	end process OUT_REG;
	
	NSL : process (state_reg, cmd_scan_row_2, d_cnt) is
	begin
		state_next	<= state_reg;
		case state_reg is
			when ST_IDLE => 
				if cmd_scan_row_2 = '1' then
					state_next	<= ST_WR_1;
				end if;
			when ST_WR_1 =>
				state_next <= ST_WR_2;
			when ST_WR_2 =>
				if cmd_scan_row_2 = '0' then
					state_next <= ST_CLR;
				else
					if d_cnt = '1' then
						state_next <= ST_CLR;
					else
						state_next <= ST_WR_1;
					end if;
				end if;
			when ST_BLANK =>
				if cmd_scan_row_2 = '0' then
					state_next <= ST_IDLE;
				end if;
			when ST_CLR =>
				if cmd_scan_row_2 = '0' then
					state_next <= ST_IDLE;
				else
					state_next <= ST_BLANK;
				end if;
		end case;		
	end process NSL;
	
	DP : process (state_reg, v_reg, p_cnt_reg) is
	begin
		v_next		<= '0';
		p_cnt_next 	<= p_cnt_reg; 
		case state_reg is
			when ST_IDLE => 
				p_cnt_next	<= (others => '0');
			when ST_WR_1 =>
				p_cnt_next	<= p_cnt_reg + 1;
			when ST_WR_2 =>
				v_next	<= '1';
			when others => null;
		end case;
	end process DP;
	
	-- Datapath 
	vo_next		<= v_reg;
	data_next 	<= data_in;
	g1_next		<= '0' & data_fifo;
	r_next		<= data_fifo;
	g2_next		<= '0' & data_reg;
	b_next		<= data_reg;
	r_out_next	<= r_reg;
	b_out_next	<= b_reg;
	g_added		<= std_logic_vector((unsigned(g1_reg) + unsigned(g2_reg)));
	g_out_next	<= g_added(NBITS_INT downto 1);
	d_cnt		<= '1' when p_cnt_reg = unsigned(conf_f_width) else '0';
	clr_fifo	<= '1' when state_reg = ST_CLR or cmd_clear = '1' else '0';
	
	-- Outputs
	data_out(3*NBITS_INT-1 downto 2*NBITS_INT)   <= r_out;
	data_out(2*NBITS_INT-1 downto NBITS_INT)	 <= g_out;
	data_out(NBITS_INT-1 downto 0)				 <= b_out;
	valid_out	<= vo_reg;
	
end architecture rtl;