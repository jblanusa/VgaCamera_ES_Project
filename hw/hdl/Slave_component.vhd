library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Slave_component is
	port
	(
		rst 						: in std_logic;
		clk_50 						: in std_logic;
		-- VGA_display
		VGA_VSync 					: in std_logic;
		HBP							: out unsigned (15 downto 0);
		HFP							: out unsigned (15 downto 0);
		VBP							: out unsigned (15 downto 0);
		VFP							: out unsigned (15 downto 0);
		Hdata						: out unsigned (15 downto 0);
		Vdata						: out unsigned (15 downto 0);
		Hsync						: out unsigned (15 downto 0);
		VSync						: out unsigned (15 downto 0);
		-- Master_component
		DisplayCom 					: out unsigned (15 downto 0);
		FBAdd 						: out unsigned (31 downto 0);
		FBLen 						: out unsigned (20 downto 0);
		DisplayStat 				: out unsigned (15 downto 0);
		--Avalon bus
		mm_params_address 		: in std_logic_vector(27 downto 0);
		mm_params_read			: in std_logic;
		mm_params_readdata 		: out std_logic_vector (31 downto 0);
		mm_params_write 		: in std_logic;
		mm_params_writedata 	: in std_logic_vector(31 downto 0);
		mm_params_waitrequest 	: out std_logic
	
	);
end Slave_component;


architecture rtl of Slave_component is
	signal FBLen_next, FBLen_reg : unsigned(20 downto 0);
	signal DisplayCom_next, DisplayCom_reg,
		   DisplayStat_next, DisplayStat_reg : unsigned(15 downto 0);
	signal FBAdd_next, FBAdd_reg: unsigned (31 downto 0);
	signal HBP_next, HBP_reg,
		   HFP_next, HFP_reg,
		   VBP_next, VBP_reg,
		   VFP_next, VFP_reg,
		   HData_next, HData_reg,
		   VData_next, VData_reg,
		   HSync_next, HSync_reg,
		   VSync_next, VSync_reg : unsigned (15 downto 0);
begin
	mm_params_waitrequest <= '0';
	FBAdd <= FBAdd_reg;
	FBLen <= FBLen_reg;
	DisplayCom <= DisplayCom_reg;
	DisplayStat <= DisplayStat_reg;
	HBP <= HBP_reg;
	HFP <= HFP_reg;
	VBP <= VBP_reg;
	VFP <= VFP_reg;
	Hdata <= Hdata_reg;
	Vdata <= Vdata_reg;
	Hsync <= Hsync_reg;
	VSync <= VSync_reg;
	
	-- Registers
	--
	REG : process (clk_50, rst)
	begin
		if rst = '1' then
	--		state_reg <= ST_STOP
			DisplayCom_reg <= (others => '0'); -- ST_STOP
			FBAdd_reg <= (others => '0');
			FBLen_reg <= (others => '0');
			DisplayStat_reg <= (others => '0');
			HBP_reg <= (others => '0');
			HFP_reg <= (others => '0');
			VBP_reg <= (others => '0');
			VFP_reg <= (others => '0');
			Hdata_reg <= (others => '0');
			Vdata_reg <= (others => '0');
			Hsync_reg <= (others => '0');
			VSync_reg <= (others => '0');
		elsif rising_edge(clk_50) then
			FBAdd_reg <= FBAdd_next;
			FBLen_reg <= FBLen_next;
			DisplayCom_reg <= DisplayCom_next;
			DisplayStat_reg <= DisplayStat_next;
			HBP_reg <= HBP_next;
			HFP_reg <= HFP_next;
			VBP_reg <= VBP_next;
			VFP_reg <= VFP_next;
			Hdata_reg <= Hdata_next;
			Vdata_reg <= Vdata_next;
			Hsync_reg <= Hsync_next;
			VSync_reg <= VSync_next;
		end if;
	end process REG;
	
	-- Next State Logic
	--
	NSL: process (FBAdd_reg, FBLen_reg, DisplayCom_reg, DisplayStat_reg,VGA_VSync, HBP_reg, VBP_reg, HFP_reg, VFP_reg, HData_reg, VData_reg, HSync_reg, VSync_reg, mm_params_write)
	begin
			FBAdd_next <= FBAdd_reg;
			FBLen_next <= FBLen_reg;
			DisplayCom_next <= DisplayCom_reg;
			DisplayStat_next(0) <= not(VGA_VSync); --jedino se on menja nezavisno od AVALON Negirati?
			HBP_next <= HBP_reg;
			HFP_next <= HFP_reg;
			VBP_next <= VBP_reg;
			VFP_next <= VFP_reg;
			Hdata_next <= Hdata_reg;
			Vdata_next <= Vdata_reg;
			Hsync_next <= Hsync_reg;
			VSync_next <= VSync_reg;
			if mm_params_write = '1' then
				if mm_params_address(3 downto 0) = "0011" then --changing command REG
					DisplayCom_next <= unsigned(mm_params_writedata(15 downto 0));
				elsif DisplayCom_reg = 0 then --change of REG only when command is STOP
					case mm_params_address(3 downto 0) is
						when "0001" => FBAdd_next <= unsigned(mm_params_writedata(31 downto 0));
						when "0010" => FBLen_next <= unsigned(mm_params_writedata(20 downto 0));
						when "0101" => HBP_next <= unsigned(mm_params_writedata(15 downto 0));
						when "0110" => HFP_next <= unsigned(mm_params_writedata(15 downto 0));
						when "0111" => VBP_next <= unsigned(mm_params_writedata(15 downto 0));
						when "1000" => VFP_next <= unsigned(mm_params_writedata(15 downto 0));
						when "1001" => Hdata_next <= unsigned(mm_params_writedata(15 downto 0));
						when "1010" => Vdata_next <= unsigned(mm_params_writedata(15 downto 0));
						when "1011" => Hsync_next <= unsigned(mm_params_writedata(15 downto 0));
						when "1100" => VSync_next <= unsigned(mm_params_writedata(15 downto 0));
						when others => NULL;
					end case;	
				end if;
			end if;
	end process NSL;
end rtl;
