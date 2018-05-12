library ieee;
use ieee.std_logic_1164.all;

entity flip is
generic (
	width	: integer := 8
);
port(	
		in1 : in std_logic_vector(width-1 downto 0);
		out1 : out std_logic_vector(width-1 downto 0)
);
end flip;

architecture behavioral of flip is
	begin
		out1 <= not in1;
end behavioral;