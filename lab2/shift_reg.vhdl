library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is
port(	I:	in std_logic_vector (3 downto 0);
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; -- positive level triggering in problem 3
		enable:		in std_logic; -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(3 downto 0) := (others =>'0')
);
end shift_reg;

architecture behav of shift_reg is
	signal storage : std_logic_vector(3 downto 0) := (others =>'0');
begin
	process(clock)
	begin
		if (enable = '1' and rising_edge(clock)) then
			case sel is
				when "00" => -- Hold 	
				when "11" => -- Load 
					storage<=I;	
				when "01" => -- Shift Left
					storage(3 downto 1)<= storage(2 downto 0);
					storage(0) <= I_SHIFT_IN;
				when "10" => -- Shift Right
					storage(2 downto 0)<= storage(3 downto 1);
					storage(3) <= I_SHIFT_IN;
				when others =>
					storage <= "0000";
			end case;
		end if;
	end process;
	O<=storage;
end behav;

