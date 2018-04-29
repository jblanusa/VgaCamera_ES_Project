library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vga_pkg.all;

entity master_driver is
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
end master_driver;

architecture rtl of master_driver is
	
	function get_pixel (address : unsigned) return std_logic_vector is
		variable hpos, vpos : integer;
		variable tmp_color : color;
	begin
		hpos := to_integer(address/4) mod 640;
		vpos := to_integer(address/4) / 640;
--		tmp_color := RED_SQUARE(vpos)(hpos);
		if (vpos >= 160 and vpos <= 320 and hpos >= 240 and hpos <= 400 ) then
			tmp_color := GREEN;
		else
			tmp_color := BLACK;
		end if;
		return tmp_color(7 downto 0) & tmp_color(15 downto 8) & tmp_color(23 downto 16) & "00000000";
	end get_pixel;
	
	type states is (ST_IDLE, ST_READB, ST_WRITEB);
	
	signal state_reg, state_next : states;
	signal burstcount_reg, burstcount_next : unsigned(5 downto 0);
	signal address_reg, address_next : unsigned(31 downto 0);
begin
	
	-- Registers
	--
	REG: process (clk_50, rst)
	begin
		if rst = '1' then
			state_reg <= ST_IDLE;
			burstcount_reg <= (others => '0');
			address_reg <= (others => '0');
		elsif rising_edge(clk_50) then
			state_reg <= state_next;
			burstcount_reg <= burstcount_next;
			address_reg <= address_next ;
		end if;
	end process REG;
	
	-- Next State Logic
	--
	NSL: process (state_reg, mm_paramm_read, burstcount_reg)
	begin
		state_next <= state_reg; --avoid latches
		case state_reg is
			when ST_IDLE => 
				if mm_paramm_read = '1' then
					state_next <= ST_READB;
				end if;
			when ST_READB => 
				state_next <= ST_WRITEB;
			when ST_WRITEB => 
				if(burstcount_reg = 1) then
					state_next <= ST_IDLE;
				end if;
		end case;
	end process NSL;
	
	-- Datapath
	--
	DP: process (state_reg, mm_paramm_read, burstcount_reg, address_reg) is
	begin
		mm_paramm_waitrequest <= '1';
		mm_paramm_readdatavalid <= '0';
		case state_reg is
			when ST_IDLE =>
				if mm_paramm_read = '1' then
					address_next <= unsigned(mm_paramm_address);
					burstcount_next <= unsigned(mm_paramm_burstcount);
				end if;
			when ST_READB =>
				mm_paramm_waitrequest <= '0';
			when ST_WRITEB => 
				if address_reg = 307199 then
					address_next <= (others => '0');
				else
					address_next <= address_reg + 4;
				end if;
				burstcount_next <= burstcount_reg - 1;
				mm_paramm_readdatavalid <= '1';
				mm_paramm_readdata <= get_pixel(address_reg);
		end case;
	end process DP;
	
end rtl;
