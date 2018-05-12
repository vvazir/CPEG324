library ieee;
use ieee.std_logic_1164.all;

entity mux is
generic (
	width	: integer := 8
);
port(	
		in1 : in std_logic_vector(width-1 downto 0);
		in2 : in std_logic_vector(width-1 downto 0);
		out1 : out std_logic_vector(width-1 downto 0);
		sel : in std_logic
);
end mux;

architecture behavioral of mux is
	begin
		process(in1,in2,sel)
		begin
			if (sel='0') then
				out1<=in1;
			else
				out1<=in2;
			end if;
		end process;
end behavioral;