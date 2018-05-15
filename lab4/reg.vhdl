library ieee;
use ieee.std_logic_1164.all;

entity reg is
generic (
	width : integer := 8
	
);
port(
	din : in std_logic_vector(width-1 downto 0);
	dout : out std_logic_vector(width-1 downto 0):= (others =>'0');
	clock : in std_logic
);
end reg;
architecture behavioral of reg is
	
	begin
		process(clock)
		begin
			if (rising_edge(clock)) then
				dout<=din;
			end if;
			
		end process;
end behavioral;