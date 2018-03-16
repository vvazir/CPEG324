library ieee;
use ieee.std_logic_1164.all;

entity mux is
generic (
	width	: integer := 8
);
port(	
		in1 : in std_logic_vector(width-1 downto 0);
		in2 : in std_logic_vector(width-1 downto 0);
		in3 : in std_logic_vector(width-1 downto 0);
		in4 : in std_logic_vector(width-1 downto 0);
		out1 : out std_logic_vector(width-1 downto 0);
		sel : in std_logic_vector(1 downto 0)
);
end mux;

architecture behavioral of mux is
	begin
		process(in1,in2,in3,in4,sel)
		begin
			case sel is
				when "00" => out1<=in1;
				when "01" => out1<=in2;
				when "10" => out1<=in3;
				when others => out1<=in4;
			end case;
		end process;
end behavioral;