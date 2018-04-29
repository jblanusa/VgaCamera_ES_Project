library ieee;
use ieee.std_logic_1164.all;

use work.vga_pkg.all;

entity image_gen is
	generic (
		H_DISPLAY: integer := 640;	-- visible pixels
		V_DISPLAY: integer := 480		-- visible pixels
	);
	port
	(
		-- inputs
		hpos : in integer range 0 to H_DISPLAY - 1;
		vpos : in integer range 0 to V_DISPLAY - 1;
		-- outputs
		Rout, Gout, Bout : out std_logic_vector(7 downto 0)
	);
end image_gen;


architecture rtl of image_gen is
	subtype color is std_logic_vector(23 downto 0);
	
								--RRGGBB
	constant BLACK : color   := x"000000";
	constant RED   : color   := x"FF0000";
	
--	type row is array(natural range 0 to 639) of color;
--	type image is array (natural range 0 to 479) of row;
	
--	constant BCKG_ROW : row := (others => BLACK);
--	constant  IMG_ROW : row := (240 to 400 => RED, others => BLACK);
	
--	constant RED_SQUARE : image := (160 to 320 => IMG_ROW, others => BCKG_ROW);
	
	signal temp_color : color;
begin
--	temp_color <= RED_SQUARE(vpos)(hpos);
	temp_color <= RED when (vpos >= 160 and vpos <= 320 and hpos >= 240 and hpos <= 400 ) else
				  BLACK;
	Rout <= temp_color(23 downto 16);
	Gout <= temp_color(15 downto 8);
	Bout <= temp_color(7 downto 0);
end rtl;
