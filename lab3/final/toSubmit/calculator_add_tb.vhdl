library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

--  A testbench has no ports.
entity calculator_add_tb is
end calculator_add_tb;

architecture behav of calculator_add_tb is
--  Declaration of the component that will be instantiated.
component calculator

port (	OpCode:     in      std_logic_vector(7 downto 0);
		DataOut:    out     std_logic_vector(7 downto 0);
		DispEn:     out     std_logic;
		clk:		in		std_logic
);
end component;

--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
signal op, data : std_logic_vector(7 downto 0);
signal en:	std_logic :='0';
signal clock:	std_logic;

begin
--  Component instantiation.
C1 : calculator
	port map(
		op,data,en,clock
	);
--  This process does the real job.
process
	type pattern_type is record
	op: 	std_logic_vector (7 downto 0);
	clk:	std_logic;
	end record;
	--  The patterns to apply.
	type pattern_array is array (natural range <>) of pattern_type;
	constant patterns : pattern_array :=
		(
("00010111", '0'),
("00010111", '1'),-- At 0 ns
("00101111", '0'),
("00101111", '1'),-- At 2 ns
("11100000", '0'),
("11100000", '1'),-- At 4 ns
("01000110", '0'),
("01000110", '1'),-- At 6 ns
("01000100", '0'),
("01000100", '1'),-- At 8 ns
("01000100", '0'),
("01000100", '1'),-- At 10 ns
("01000100", '0'),
("01000100", '1'),-- At 12 ns
("01000100", '0'),
("01000100", '1'),-- At 14 ns
("01000100", '0'),
("01000100", '1'),-- At 16 ns
("01000100", '0'),
("01000100", '1'),-- At 18 ns
("01000100", '0'),
("01000100", '1'),-- At 20 ns
("01000100", '0'),
("01000100", '1'),-- At 22 ns
("01000100", '0'),
("01000100", '1'),-- At 24 ns
("01000100", '0'),
("01000100", '1'),-- At 26 ns
("01000100", '0'),
("01000100", '1'),-- At 28 ns
("01000100", '0'),
("01000100", '1'),-- At 30 ns
("01000100", '0'),
("01000100", '1'),-- At 32 ns
("01000100", '0'),
("01000100", '1'),-- At 34 ns
("01000100", '0'),
("01000100", '1'),-- At 36 ns
("01000100", '0'),
("01000100", '1'),-- At 38 ns
("11000000", '0'),
("11000000", '1'),-- At 40 ns
("01000100", '0'),
("01000100", '1'),-- At 42 ns
("11000000", '0'),
("11000000", '1')
-- At 44 ns
		);
	begin
		--  Check each pattern.
		for n in patterns'range loop
			--  Set the inputs.
			op <= patterns(n).op;
			clock <= patterns(n).clk;
			--  Wait for the results.
			wait for 1 ns;
			--  If disp_en = '1', print out the data in a formated manner.
			if clock='1' then
				if ((to_integer(signed(data)))<0) then
					assert ((en /= '1')) report "-" & integer'image(((-1*to_integer(signed(data))) mod 10000)/1000)&"" & integer'image(((-1*to_integer(signed(data))) mod 1000)/100)&"" & integer'image(((-1*to_integer(signed(data))) mod 100)/10)&"" & integer'image((-1*to_integer(signed(data))) mod 10) severity note;
				else
					assert ((en /= '1')) report "" & integer'image(((to_integer(signed(data))) mod 10000)/1000)&"" & integer'image(((to_integer(signed(data))) mod 1000)/100)&"" & integer'image(((to_integer(signed(data))) mod 100)/10)&"" & integer'image((to_integer(signed(data))) mod 10)severity note;
				end if;
			end if;
		end loop;
		
		assert false report "end of test" severity note;
		--  Wait forever; this will finish the simulation.
		wait;
	end process;
end behav;
