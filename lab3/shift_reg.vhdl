library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is
port(
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic; -- 0:Shift right; 1: load
		clock:		in std_logic; -- positive level triggering in problem 3
		O:			out std_logic
);
end shift_reg;

architecture behav of shift_reg is
	signal storage : std_logic_vector (2 downto 0) := (others =>'0');
begin
	process(clock)
	begin
		if (rising_edge(clock)) then
			case sel is
				when '1' => -- Load 
					storage(0)<='0';
					storage(1)<='1';
					storage(2)<=I_SHIFT_IN;					
				when '0' => -- Shift Right
					storage(0)<= storage(1);
					storage(1)<= storage(2);
					storage(2) <= '0';
				when others =>
					storage <= "000";
			end case;
		end if;
	end process;
	O<=storage(0);
end behav;

