library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync is
	port (
		-- vga clock
		clk : in std_logic;
		reset : in std_logic;
		hpos : out unsigned (15 downto 0);
		vpos : out unsigned (15 downto 0);
		-- communication with fifo
		fifo_empty : in std_logic;
		fifo_full : in std_logic;
		new_pixel : out std_logic;
		Rin, Gin, Bin : in std_logic_vector(7 downto 0);
		-- conduit signals
		Rout, Gout, Bout : out std_logic_vector(7 downto 0);
		hsync, vsync : out std_logic;
		-- Timing parameters
		HBP		: in unsigned (15 downto 0);
		HFP		: in unsigned (15 downto 0);
		VBP		: in unsigned (15 downto 0);
		VFP		: in unsigned (15 downto 0);
		Hdata	: in unsigned (15 downto 0);
		Vdata	: in unsigned (15 downto 0);
		HS		: in unsigned (15 downto 0);
		VS		: in unsigned (15 downto 0)
	);
end vga_sync;

architecture rtl of vga_sync is
	constant ZERO : unsigned(15 downto 0) := (others => '0');

	type state is (ST_IDLE, ST_CNT);
	signal state_reg, state_next : state;
	
	-- registers
	signal hcount_reg, hcount_next : unsigned (15 downto 0);
	signal vcount_reg, vcount_next : unsigned (15 downto 0);
	signal disp_ena : std_logic;
	
	signal HPeriod, VPeriod : unsigned(15 downto 0);
	
begin
	
	HPeriod <= HS + HBP + Hdata + HFP;
	VPeriod <= VS + VBP + Vdata + VFP;
	
 	
	-- Registers
	REG : process(clk, reset) is
	begin
		if reset = '1' then
			hcount_reg <= ZERO;
			vcount_reg <= ZERO;
			state_reg <= ST_IDLE;
		elsif rising_edge(clk) then
			hcount_reg <= hcount_next;
			vcount_reg <= vcount_next;
			state_reg <= state_next;
		end if;
	end process REG;
	
	-- Next-State Logic
	-- 
	NSL : process(state_reg, fifo_empty, fifo_full) is
	begin
		state_next <= state_reg; -- avoid latches
		case state_reg is
			when ST_IDLE =>
				if fifo_full = '1' then
					state_next <= ST_CNT;
				end if;
			when ST_CNT  =>
				if fifo_empty = '1' then
					state_next <= ST_IDLE;
				end if;
			when others=>
				null;
		end case;
	end process NSL;

	-- Datapath
	-- 
	DP : process(state_reg, hcount_reg, vcount_reg) is
	begin
		-- avoid latches
		hcount_next <= hcount_reg;
		vcount_next <= vcount_reg;
		disp_ena <= '0';
		case state_reg is
			when ST_IDLE =>
				hcount_next <= Hdata + HFP;
				vcount_next <= Vdata + VFP;
			when ST_CNT =>
				if (hcount_reg < HPeriod - 1) then
					hcount_next <= hcount_reg + 1;
				else
					hcount_next <= ZERO;
					if (vcount_reg < VPeriod - 1) then
						vcount_next <= vcount_reg + 1;
					else
						vcount_next <= ZERO;
					end if;
				end if;
				
				if hcount_reg < Hdata and vcount_reg < Vdata then
					disp_ena <= '1';
				end if;
		end case;
	end process DP;
	
	-- outputs
	--
	Rout <= Rin when disp_ena = '1' else (others => '0');
	Gout <= Gin when disp_ena = '1' else (others => '0');
	Bout <= Bin when disp_ena = '1' else (others => '0');
	
--	new_pixel <= not clk when disp_ena = '1' else 
--					 '0';
	
	new_pixel <=  disp_ena;
	
	hsync <= '1' when hcount_reg < Hdata + HFP or hcount_reg > Hdata + HFP + HS else
				'0';
	
	vsync <= '1' when vcount_reg < Vdata + VFP or vcount_reg > Vdata + VFP + VS else
				'0'; 
				
	hpos  <=  hcount_reg when hcount_reg < Hdata else
				 ZERO; 
				
	vpos  <=  vcount_reg when vcount_reg < Vdata else
				 ZERO;
				 
end rtl;