library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.vga_pkg.all;

entity tb_fifo is
end tb_fifo ;


architecture bench of tb_fifo  is
	
	constant half_period : time := 10 ns;
	constant half_period2 : time := 5 ns;

	
	signal vga_clk: std_logic := '0';
	signal wr_clk: std_logic := '0';
	signal rst_tb : std_logic := '1';
	
	signal hpos_tb : unsigned(15 downto 0);
	signal vpos_tb : unsigned(15 downto 0);
	
	signal R_fifo_in, G_fifo_in, B_fifo_in : std_logic_vector(7 downto 0);
	signal R_fifo_out, G_fifo_out, B_fifo_out : std_logic_vector(7 downto 0);
	signal Rout_tb, Gout_tb, Bout_tb : std_logic_vector(7 downto 0);
	signal hsync_tb, vsync_tb : std_logic;
	signal npix_tb : std_logic;
	
	-- fifo signals
	signal data_in, data_out : std_logic_vector(31 downto 0);
	signal read_full, read_empty : std_logic;
	signal write_full, write_empty, write_halffull : std_logic;
	signal write_req, read_req : std_logic;
	signal wr_used : std_logic_vector(4 downto 0);
	signal aclr_tb : std_logic;
	
	signal done : boolean := false;
begin
	
	
	vga_clk <= not vga_clk after half_period when not done;
	wr_clk <= not wr_clk after half_period2 when not done;
	rst_tb <= '0' after 3*half_period/4;
		
--	data_in <= (15 downto 10 => R_fifo_in(7 downto 2), 23 downto 18 => G_fifo_in(7 downto 2), 31 downto 26 => B_fifo_in(7 downto 2), others => '0');
	data_in(15 downto 8)  <= R_fifo_in;
	data_in(23 downto 16) <= G_fifo_in;
	data_in(31 downto 24) <= B_fifo_in;
	data_in(7 downto 0) <= (others => '0');
	
	R_fifo_out <= data_out(15 downto 8);
	G_fifo_out <= data_out(23 downto 16);
	B_fifo_out <= data_out(31 downto 24);
	
	read_req <= npix_tb;
	write_halffull <= '1' when wr_used = "10000" else
					  '0';
	-- VGA_sync component
	--
	vga: component vga_sync
		port map(
			clk => vga_clk,
			reset => rst_tb,
			hpos => hpos_tb,
			vpos => vpos_tb,
			fifo_empty => read_empty,
			fifo_full => read_full,
			new_pixel => npix_tb,
			Rin => R_fifo_out,
			Gin => G_fifo_out,
			Bin => B_fifo_out,
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

	-- Input image generator component
	--
	igen: component fifo_input_gen
		port map(
			clk => wr_clk,
			rst => rst_tb,
			fifo_empty => write_empty,
			fifo_full => write_full,
			fifo_halffull => write_halffull,
			fifo_write => write_req,
			fifo_clr => aclr_tb,
			Rout => R_fifo_in,
			Gout => G_fifo_in,
			Bout => B_fifo_in	
		);

   -- fifo component
   --
   I_FIFO : component fifo
      port map (
        aclr => aclr_tb,
		data  => data_in,
		rdclk => vga_clk,
		rdreq => read_req,
		wrclk  => wr_clk,
		wrreq  => write_req,
		q => data_out,
		rdempty  => read_empty,
		rdfull  => read_full,
		wrempty => write_empty,
		wrfull => write_full,
		wrusedw => wr_used
		);
		
	
	vga_out : process (vga_clk)
		file file_pointer: text open WRITE_MODE is "vga_out.txt";
		variable line_el: line;
	begin
		if rising_edge(vga_clk) then
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

end bench;
