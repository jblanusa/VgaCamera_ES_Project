library ieee;
use ieee.std_logic_1164.all;

use work.vga_pkg.all;

entity fifo_input_gen is
	generic (
		H_DISPLAY: integer := 640;	-- visible pixels
		V_DISPLAY: integer := 480		-- visible pixels
	);
	port
	(
		clk, rst : in std_logic;
		-- inputs
		fifo_empty, fifo_full, fifo_halffull : in std_logic;
		-- outputs
		fifo_write : out std_logic;
		fifo_clr   : out std_logic;
		Rout, Gout, Bout : out std_logic_vector(7 downto 0)
	);
end fifo_input_gen;


architecture rtl of fifo_input_gen is

	type state is (ST_START, ST_IDLE, ST_LOAD);
	signal state_reg, state_next : state;
	
	signal temp_color : color;
	
	signal hpos_reg, hpos_next : integer range 0 to H_DISPLAY - 1;
	signal vpos_reg, vpos_next : integer range 0 to V_DISPLAY - 1;
begin
	
		-- Registers
	REG : process(clk, rst) is
	begin
		if rst = '1' then
			hpos_reg <= 0;
			vpos_reg <= 0;
			state_reg <= ST_START;
		elsif rising_edge(clk) then
			hpos_reg <= hpos_next;
			vpos_reg <= vpos_next;
			state_reg <= state_next;
		end if;
	end process REG;
	
	
	-- Next-State Logic
	-- 
	NSL : process(fifo_halffull, fifo_full) is
	begin
		state_next <= state_reg; -- avoid latches
		case state_reg is
			when ST_START => 
					state_next <= ST_LOAD;
			when ST_IDLE =>
				if fifo_halffull = '1' then
					state_next <= ST_LOAD;
				end if;
			when ST_LOAD  =>
				if fifo_full = '1' then
					state_next <= ST_IDLE;
				end if;
			when others=>
				null;
		end case;
	end process NSL;
	
	
	-- Datapath
	--
	DP : process(state_reg, hpos_reg, vpos_reg, fifo_full) is
	begin
		-- avoid latches
		hpos_next <= hpos_reg;
		vpos_next <= vpos_reg;
		case state_reg is
			when ST_START =>  
				hpos_next <= 0;
				vpos_next <= 0;
			when ST_IDLE =>
				null;
			when ST_LOAD =>
				if fifo_full = '0' then
					if (hpos_reg < H_DISPLAY - 1) then
						hpos_next <= hpos_reg + 1;
					else
						hpos_next <= 0;
						if (vpos_reg < V_DISPLAY - 1) then
							vpos_next <= vpos_reg + 1;
						else
							vpos_next <= 0;
						end if;
					end if;
				end if;
		end case;
	end process DP;
	
	
	-- Outputs
	--
	fifo_clr  <= '1' when state_reg = ST_START else
				 '0';
	
	fifo_write <= '1' when state_reg = ST_LOAD else
			  	  '0';
	
--	temp_color <= RED_SQUARE(vpos_reg)(hpos_reg);
	temp_color <= BLUE when (vpos_reg >= 160 and vpos_reg <= 320 and hpos_reg >= 240 and hpos_reg <= 400 ) else
			      BLACK;
				  
	Rout <= temp_color(23 downto 16);
	Gout <= temp_color(15 downto 8);
	Bout <= temp_color(7 downto 0);
end rtl;
