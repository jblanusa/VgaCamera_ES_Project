library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

use work.vga_pkg.all;

entity tb_vga_top is
end tb_vga_top;


architecture bench of tb_vga_top is
	
	constant half_period : time := 10 ns;
	constant half_period2 : time := 5 ns;

	
	signal vga_clk: std_logic := '0';
	signal master_clk: std_logic := '0';
	signal rst_tb : std_logic := '1';
	
	-- vga signals
	signal hsync_tb, vsync_tb : std_logic;
	signal R_fifo_out, G_fifo_out, B_fifo_out : std_logic_vector(7 downto 0);
	signal Rout_tb, Gout_tb, Bout_tb : std_logic_vector(7 downto 0);
	
	-- fifo signals
	signal fifo_data_in, fifo_data_out : std_logic_vector(31 downto 0);
	signal write_full, write_empty, write_halffull : std_logic;
	signal write_req, read_req : std_logic;
	signal read_full, read_empty : std_logic;
	signal wr_used : std_logic_vector(5 downto 0);
	signal aclr_top : std_logic;
	
	-- Master-slave communication	
	signal DisplayCom_top 	: unsigned (15 downto 0);
	signal FBAdd_top 		: unsigned (25 downto 0);
	signal FBLen_top 		: unsigned (20 downto 0);
	signal DisplayStat_top  : unsigned (15 downto 0);
	
	-- Avalon master signals emulation
	signal master_address 		: std_logic_vector (31 downto 0);
	signal master_read			: std_logic;
	signal master_readdata		: std_logic_vector(31 downto 0);
	signal master_readdatavalid 	: std_logic;	
	signal master_waitrequest	: std_logic;	
	signal master_burstcount		: std_logic_vector(5 downto 0);
	
	signal done : boolean := false;
begin
	
	vga_clk <= not vga_clk after half_period when not done;
	master_clk <= not master_clk after half_period2 when not done;
	rst_tb <= '0' after 3*half_period/4;
		
	R_fifo_out <= fifo_data_out(15 downto 8);
	G_fifo_out <= fifo_data_out(23 downto 16);
	B_fifo_out <= fifo_data_out(31 downto 24);
	
	write_halffull <=  '1' when (unsigned(wr_used) < 48 and write_full = '0' and unsigned(wr_used) /= 0) else
					   '0';
	
	-- VGA_sync component
	--
	I_VGA: component vga_sync
		port map(
			clk => vga_clk,
			reset => rst_tb,
			hpos => open,
			vpos => open,
			fifo_empty => read_empty,
			fifo_full => read_full,
			new_pixel => read_req,
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

	
   -- fifo component
   --
   I_FIFO : component fifo64
      port map (
        aclr  => aclr_top,
		data  => fifo_data_in,
		rdclk => vga_clk,
		rdreq => read_req,
		wrclk => master_clk,
		wrreq => write_req,
		q 	  => fifo_data_out,
		rdempty => read_empty,
		rdfull  => read_full,
		wrempty => write_empty,
		wrfull  => write_full,
		wrusedw => wr_used
		);
	
   -- Master driver component
   --
   I_DRIVER : component master_driver
   		port map(
	   		clk_50 	=> master_clk,
			rst  	=> rst_tb,
			--Avalon master bus
			mm_paramm_address 	=> master_address,
			mm_paramm_read 		=> master_read,
			mm_paramm_readdata 	=> master_readdata,
			mm_paramm_readdatavalid => master_readdatavalid,	
			mm_paramm_waitrequest 	=> master_waitrequest, 	
			mm_paramm_burstcount	=> master_burstcount	
   		);
	
	
   -- Avalon master component
   --
   I_MASTER : component Master_component
      port map (
        clk_50 => master_clk,
		rst => rst_tb,
		--FIFO
		aclr => aclr_top,
		data_out => fifo_data_in,
		en_in => write_req,
		half => write_halffull,
		empty => write_empty,
		--Slave_component
		DisplayCom => to_unsigned(1,16),
		FBAdd => to_unsigned(0,32),
		FBLen => to_unsigned(640*480,21),
		DisplayStat => to_unsigned(0,16),
		--Avalon bus
		mm_paramm_address 	=> master_address,
		mm_paramm_read 		=> master_read,
		mm_paramm_readdata 	=> master_readdata,
		mm_paramm_readdatavalid => master_readdatavalid,	
		mm_paramm_waitrequest 	=> master_waitrequest, 	
		mm_paramm_burstcount	=> master_burstcount	
		);
		
	vga_out : process (vga_clk)
		file file_pointer: text open WRITE_MODE is "tb_vga_top_out.txt";
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
