library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.vga_pkg.all;

entity tb_vga_sync is
end tb_vga_sync ;

architecture bench of tb_vga_sync  is

	constant half_period : time := 10 ns;
	
	signal clk_tb : std_logic := '0';
	signal rst_tb : std_logic := '1';
	
	signal hpos_tb : unsigned(15 downto 0);
	signal vpos_tb : unsigned(15 downto 0);
	
	signal R_tb, G_tb, B_tb : std_logic_vector(7 downto 0);
	signal Rout_tb, Gout_tb, Bout_tb : std_logic_vector(7 downto 0);
	signal hsync_tb, vsync_tb : std_logic;
	signal npix_tb : std_logic;
	
	signal done : boolean;
begin
		
	clk_tb <= not clk_tb after half_period when not done;
	rst_tb <= '0' after 3*half_period/4;
	
	vga: component vga_sync
		port map(
			clk => clk_tb,
			reset => rst_tb,
			hpos => hpos_tb,
			vpos => vpos_tb,
			fifo_empty => '0',
			fifo_full => '1',
			new_pixel => npix_tb,
			Rin => R_tb,
			Gin => G_tb,
			Bin => B_tb,
			Rout => Rout_tb,
			Gout => Gout_tb,
			Bout => Bout_tb,
			hsync => hsync_tb,
			vsync => vsync_tb,
			HBP =>  H_BP,
			HFP =>  H_FP,
			VBP =>  V_BP,
			VFP =>  V_FP,
			Hdata =>  H_DISPLAY,
			Vdata =>  V_DISPLAY,
			HS =>  H_SYNC,
			VS =>  V_SYNC
		);

	igen: component image_gen
		port map(
			hpos => to_integer(hpos_tb),
			vpos => to_integer(vpos_tb),
			Rout => R_tb,
			Gout => G_tb,
			Bout => B_tb	
		);
		
	vga_out : process (clk_tb)
		file file_pointer: text open WRITE_MODE is "vga_out.txt";
		variable line_el: line;
	begin
		if rising_edge(clk_tb) then
			--line_el := "1";
			-- Write the time
			write(line_el, (now / 1 ns) * 1000 ps); --write the line.
			write(line_el, ':'); --write the line.
			--writeline(file_pointer, line_el); --write the contents into the file.
			
			-- Write the hsync
			write(line_el, ' ');
			write(line_el, hsync_tb ); --write the line.
			--writeline(file_pointer, line_el); --write the contents into the file.
			
			-- Write the vsync
			write(line_el, ' ');
			write(line_el, vsync_tb ); --write the line.
			--writeline(file_pointer, line_el); --write the contents into the file.
			
			-- Write the red
			write(line_el, ' ');
			write(line_el, Rout_tb(7 downto 5)); --write the line.
			--writeline(file_pointer, line_el); --write the contents into the file.
			
			-- Write the green
			write(line_el, ' ');
			write(line_el, Gout_tb(7 downto 5)); --write the line.
			--writeline(file_pointer, line_el); --write the contents into the file.
			
			-- Write the blue
			write(line_el, ' ');
			write(line_el, Bout_tb(7 downto 6)); --write the line.
			
			writeline(file_pointer, line_el); --write the contents into the file.
		end if;
	end process; 
	
--	always : PROCESS                                             
--	BEGIN     
--		done <= false;                                                
-- 		while not(hpos_tb = 639 and vpos_tb = 479) loop
-- 		end loop;
-- 		done <= true;
--	WAIT;                                                        
--	END PROCESS always; 
end bench;
